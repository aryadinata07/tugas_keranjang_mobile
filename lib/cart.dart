import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tugas_keranjang/model/cart_item.dart';
import 'package:tugas_keranjang/controllers/cart_controller.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(() {
        final List<CartItem> cartItems = cartController.cartItems;

        if (cartItems.isEmpty) {
          return Center(
            child: Text("Cart is empty"),
          );
        }

        return ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return CartItemWidget(cartItem: item);
          },
        );
      }),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late String _localImagePath;
  late bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLocalImage();
  }

  Future<void> _loadLocalImage() async {
    final String fileName = '${widget.cartItem.id}.png';
    final Directory directory = await getApplicationDocumentsDirectory();
    final String localImagePath = '${directory.path}/$fileName';

    final File imageFile = File(localImagePath);
    if (await imageFile.exists()) {
      setState(() {
        _localImagePath = localImagePath;
        _isImageLoaded = true;
      });
    } else {
      final String imageUrl = widget.cartItem.image;
      final http.Response response = await http.get(Uri.parse(imageUrl));
      await imageFile.writeAsBytes(response.bodyBytes);
      setState(() {
        _localImagePath = localImagePath;
        _isImageLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _isImageLoaded
          ? Image.file(
              File(_localImagePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          : CircularProgressIndicator(), 
      title: Text(widget.cartItem.title),
      subtitle: Text('\$${widget.cartItem.price}'),
      trailing: IconButton(
        onPressed: () {
          Get.find<CartController>().removeFromCart(widget.cartItem.id);
        },
        icon: Icon(Icons.remove_shopping_cart),
      ),
    );
  }
}
