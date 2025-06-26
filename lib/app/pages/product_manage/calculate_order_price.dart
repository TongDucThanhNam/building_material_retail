import 'package:flutter/material.dart';

class CalculateOrderPricePage extends StatelessWidget {
  const CalculateOrderPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tính đơn hàng')),
      body: const Center(child: Text('Trang tính đơn hàng (Calculate Order Price Page)')),
    );
  }
}
