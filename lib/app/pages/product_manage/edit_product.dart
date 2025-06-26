import 'package:flutter/material.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thay đổi thông tin vật tư')),
      body: const Center(child: Text('Trang thay đổi thông tin vật tư (Edit Product Page)')),
    );
  }
}
