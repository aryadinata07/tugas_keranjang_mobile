import 'package:get/get.dart';
import 'package:tugas_keranjang/model/cart_item.dart';
import 'package:tugas_keranjang/database/cart_database.dart';

class CartController extends GetxController {
  final CartDatabase _cartDatabase = CartDatabase();

  var cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final items = await _cartDatabase.getCartItems();
    cartItems.assignAll(items);
  }

  Future<void> addToCart(CartItem item) async {
    await _cartDatabase.addItemToCart(item);
    await fetchCartItems();
  }

  Future<void> removeFromCart(int id) async {
    await _cartDatabase.removeItemFromCart(id);
    await fetchCartItems();
  }

  Future<List<CartItem>> getCartItems() async {
    return await _cartDatabase.getCartItems();
  }
}
