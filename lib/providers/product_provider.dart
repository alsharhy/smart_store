import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Product> products = [];
  List<Product> favorites = [];
  List<CartItem> cart = [];

  bool isLoading = false;
  bool offlineMode = false;

  StreamSubscription<QuerySnapshot>? _productsSubscription;
  StreamSubscription<QuerySnapshot>? _favoritesSubscription;
  StreamSubscription<QuerySnapshot>? _cartSubscription;
  StreamSubscription<User?>? _authSubscription;

  ProductProvider() {
    // Listen to Auth state changes to set up/tear down favorites subscription
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _listenToFavorites(user.uid);
        _listenToCart(user.uid);
      } else {
        _favoritesSubscription?.cancel();
        _cartSubscription?.cancel();
        favorites = [];
        cart = [];
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    _favoritesSubscription?.cancel();
    _cartSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    try {
      await initializeProductsMigration();
      _listenToProducts();
    } catch (e) {
      debugPrint("Initialize error: $e");
      // If Firestore completely fails, fallback to API directly
      await _fallbackToApi();
    }
  }

  // Automatic Migration: checks if products exist in Firestore. If not, fetches from Mock API and uploads them.
  Future<void> initializeProductsMigration() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .limit(1)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 10));
      if (snapshot.docs.isEmpty) {
        // Fetch mock products from mock API
        final mockProducts = await ApiService.fetchProducts();
        final batch = _firestore.batch();
        for (var product in mockProducts) {
          final docRef = _firestore.collection('products').doc(product.id.toString());
          batch.set(docRef, product.toMap());
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint("Migration error: $e");
      // If Firestore is unavailable, fallback directly to API
      await _fallbackToApi();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fallback: Load products directly from API when Firestore is unavailable
  Future<void> _fallbackToApi() async {
    try {
      debugPrint("Falling back to API directly...");
      final apiProducts = await ApiService.fetchProducts();
      products = apiProducts;
      offlineMode = true;
      notifyListeners();

      // Save to local cache
      await LocalStorageService.saveJson(
        "products.json",
        products.map((e) => e.toMap()).toList(),
      );
      debugPrint("Loaded ${products.length} products from API fallback");
    } catch (apiError) {
      debugPrint("API fallback also failed: $apiError");
      // Last resort: load from local cache
      await _loadFromCache();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load products from local cache
  Future<void> _loadFromCache() async {
    try {
      final data = await LocalStorageService.readJson("products.json");
      if (data.isNotEmpty) {
        products = data.map<Product>((e) => Product.fromDoc(Map<String, dynamic>.from(e))).toList();
        offlineMode = true;
        debugPrint("Loaded ${products.length} products from cache");
      } else {
        debugPrint("No cached products found");
      }
    } catch (e) {
      debugPrint("Cache load error: $e");
    }
    notifyListeners();
  }

  // Real-time listener for products in Firestore
  void _listenToProducts() {
    _productsSubscription?.cancel();
    _productsSubscription = _firestore.collection('products').snapshots().listen((snapshot) async {
      products = snapshot.docs.map((doc) => Product.fromDoc(doc.data())).toList();
      offlineMode = false;
      notifyListeners();

      // Save to local cache in case of offline mode
      try {
        await LocalStorageService.saveJson(
          "products.json",
          products.map((e) => e.toMap()).toList(),
        );
      } catch (e) {
        debugPrint("Local storage save error: $e");
      }
    }, onError: (error) async {
      debugPrint("Firestore products stream error: $error");
      offlineMode = true;
      // Fallback: try API first, then cache
      await _fallbackToApi();
    });
  }

  // Real-time listener for user-specific favorites
  void _listenToFavorites(String userId) {
    _favoritesSubscription?.cancel();
    _favoritesSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) async {
      favorites = snapshot.docs.map((doc) => Product.fromDoc(doc.data())).toList();
      notifyListeners();

      // Save to local cache
      try {
        await LocalStorageService.saveJson(
          "favorites.json",
          favorites.map((e) => e.toMap()).toList(),
        );
      } catch (e) {
        debugPrint("Local storage favorites save error: $e");
      }
    }, onError: (error) async {
      debugPrint("Firestore favorites stream error: $error");
      // Fallback to local cache
      final data = await LocalStorageService.readJson("favorites.json");
      favorites = data.map<Product>((e) => Product.fromDoc(Map<String, dynamic>.from(e))).toList();
      notifyListeners();
    });
  }

  // Real-time listener for user-specific cart
  void _listenToCart(String userId) {
    _cartSubscription?.cancel();
    _cartSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .listen((snapshot) async {
      cart = snapshot.docs.map((doc) => CartItem.fromJson(doc.data())).toList();
      notifyListeners();

      // Save to local cache
      try {
        await LocalStorageService.saveJson(
          "cart.json",
          cart.map((e) => e.toJson()).toList(),
        );
      } catch (e) {
        debugPrint("Local storage cart save error: $e");
      }
    }, onError: (error) async {
      debugPrint("Firestore cart stream error: $error");
      // Fallback to local cache
      final data = await LocalStorageService.readJson("cart.json");
      cart = data.map<CartItem>((e) => CartItem.fromJson(Map<String, dynamic>.from(e))).toList();
      notifyListeners();
    });
  }

  // Toggle favorite in Firestore (Optional requirements)
  Future<void> toggleFavorite(Product product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(product.id.toString());

    final exists = favorites.any((e) => e.id == product.id);

    try {
      if (exists) {
        await docRef.delete();
      } else {
        await docRef.set(product.toMap());
      }
    } catch (e) {
      debugPrint("Firestore toggle favorite error: $e");
      // Fallback local toggle in case of network issue
      if (exists) {
        favorites.removeWhere((e) => e.id == product.id);
      } else {
        favorites.add(product);
      }
      notifyListeners();
    }
  }

  bool isFavorite(int id) {
    return favorites.any((e) => e.id == id);
  }

  // Add to cart
  Future<void> addToCart(Product product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(product.id.toString());

    final existingIndex = cart.indexWhere((e) => e.productId == product.id);

    try {
      if (existingIndex >= 0) {
        // Increment quantity
        final item = cart[existingIndex];
        await docRef.update({'quantity': item.quantity + 1});
      } else {
        // Add new
        final newItem = CartItem(productId: product.id, quantity: 1);
        await docRef.set(newItem.toJson());
      }
    } catch (e) {
      debugPrint("Firestore add to cart error: $e");
      // Fallback local
      if (existingIndex >= 0) {
        cart[existingIndex].quantity++;
      } else {
        cart.add(CartItem(productId: product.id, quantity: 1));
      }
      notifyListeners();
    }
  }

  // Remove from cart
  Future<void> removeFromCart(int productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId.toString());

    try {
      await docRef.delete();
    } catch (e) {
      debugPrint("Firestore remove from cart error: $e");
      // Fallback local
      cart.removeWhere((e) => e.productId == productId);
      notifyListeners();
    }
  }

  // Update cart item quantity
  Future<void> updateCartQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId.toString());

    try {
      await docRef.update({'quantity': quantity});
    } catch (e) {
      debugPrint("Firestore update cart error: $e");
      // Fallback local
      final existingIndex = cart.indexWhere((e) => e.productId == productId);
      if (existingIndex >= 0) {
        cart[existingIndex].quantity = quantity;
      }
      notifyListeners();
    }
  }
}
