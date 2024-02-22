import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:tugas_keranjang/home.dart';
import 'package:tugas_keranjang/controllers/cart_controller.dart'; // Import halaman Home Anda

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final cartController =
      Get.put(CartController()); // Inisialisasi CartController

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      home: home(),
    );
  }
}
