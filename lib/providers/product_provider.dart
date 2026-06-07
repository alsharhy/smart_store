import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = [];

  List<Product> favorites = [];

  bool isLoading = false;

  bool offlineMode = false;

  Future<void> initialize() async {
    await loadFavorites();

    await loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading = true;

    notifyListeners();

    try {
      products = await ApiService.fetchProducts();

      offlineMode = false;

      await LocalStorageService.saveJson(
        "products.json",
        products.map((e) => e.toJson()).toList(),
      );
    } catch (_) {
      offlineMode = true;

      final data = await LocalStorageService.readJson("products.json");

      products = data.map<Product>((e) => Product.fromJson(e)).toList();
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final data = await LocalStorageService.readJson("favorites.json");

    favorites = data.map<Product>((e) => Product.fromJson(e)).toList();

    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    final exists = favorites.any((e) => e.id == product.id);

    if (exists) {
      favorites.removeWhere((e) => e.id == product.id);
    } else {
      favorites.add(product);
    }

    await LocalStorageService.saveJson(
      "favorites.json",
      favorites.map((e) => e.toJson()).toList(),
    );

    notifyListeners();
  }

  bool isFavorite(int id) {
    return favorites.any((e) => e.id == id);
  }
}
