import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tugas_keranjang/model/cart_item.dart';

class CartDatabase {
  static final CartDatabase _instance = CartDatabase._();

  factory CartDatabase() => _instance;

  static Database? _database;

  CartDatabase._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "CartDB.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE CartItems (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            price TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  Future<int> addItemToCart(CartItem item) async {
    final db = await database;
    return await db.insert('CartItems', item.toMap());
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('CartItems');

    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i]['id'],
        title: maps[i]['title'],
        price: maps[i]['price'],
        image: maps[i]['image'],
      );
    });
  }

  Future<void> removeItemFromCart(int id) async {
    final db = await database;
    await db.delete(
      'CartItems',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
