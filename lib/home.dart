import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:tugas_keranjang/controllers/cart_controller.dart';
import 'package:tugas_keranjang/constant/constant.dart';
import 'package:tugas_keranjang/cart.dart';
import 'package:tugas_keranjang/model/cart_item.dart';

class home extends StatelessWidget {
  const home({super.key});

  Future<List<Map<String, dynamic>>> _getProduct() async {
    final response = await http.get(Uri.parse(kProductUrl));
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((product) => Map<String, dynamic>.from(product)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Text("Flutter API"),
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.to(() => Cart());
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: _getProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData && (snapshot.data as List).isEmpty) {
              return Center(
                child: Text("No data"),
              );
            } else {
              return GridView.builder(
                itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Image.network(
                                product['image'],
                                width: 100,
                                height: 100,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${product['title']}",
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${product['price']}",
                                ),
                                // add to cart
                                IconButton(
                                  onPressed: () {
                                    final cartItem = CartItem(
                                      id: product['id'],
                                      title: product['title'],
                                      price: product['price'].toString(), 
                                      image: product['image'],
                                    );
                                    // Tambahkan ke keranjang belanja
                                    Get.find<CartController>()
                                        .addToCart(cartItem);
                                    Get.snackbar(
                                      'Added to Cart',
                                      'Item added to cart successfully!',
                                    );
                                  },
                                  icon: Icon(Icons.add_shopping_cart_outlined),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
              );
            }
          },
        ));
  }
}
