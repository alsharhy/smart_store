import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cart_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smart_store_cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE cart (
  productId $idType,
  quantity $integerType
)
''');
  }

  // Insert or update cart item
  Future<void> insertCartItem(CartItem item) async {
    final db = await instance.database;
    await db.insert(
      'cart',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all cart items
  Future<List<CartItem>> getCartItems() async {
    final db = await instance.database;
    final maps = await db.query('cart');

    if (maps.isNotEmpty) {
      return maps.map((json) => CartItem.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  // Update item quantity
  Future<void> updateCartItemQuantity(int productId, int quantity) async {
    final db = await instance.database;
    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  // Delete item
  Future<void> deleteCartItem(int productId) async {
    final db = await instance.database;
    await db.delete(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  // Clear cart
  Future<void> clearCart() async {
    final db = await instance.database;
    await db.delete('cart');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
