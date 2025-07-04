
import 'package:flutter/material.dart';


class CalculateOrderPricePage extends StatefulWidget {
  const CalculateOrderPricePage({super.key});

  @override
  State<CalculateOrderPricePage> createState() => _CalculateOrderPricePageState();
}

class _CalculateOrderPricePageState extends State<CalculateOrderPricePage> {
  final List<Map<String, dynamic>> _products = [
    {'name': 'Xi măng', 'price': 100000},
    {'name': 'Cát', 'price': 50000},
    {'name': 'Gạch', 'price': 2000},
    {'name': 'Thép', 'price': 150000},
  ];
  int _selectedProductIndex = 0;
  int _quantity = 1;

  int get _unitPrice => _products[_selectedProductIndex]['price'] as int;
  int get _totalPrice => _unitPrice * _quantity;

  void _onProductChanged(int? index) {
    if (index != null) {
      setState(() {
        _selectedProductIndex = index;
      });
    }
  }

  void _onQuantityChanged(String value) {
    final qty = int.tryParse(value);
    setState(() {
      _quantity = (qty != null && qty > 0) ? qty : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tính đơn hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn sản phẩm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _selectedProductIndex,
              items: List.generate(_products.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(_products[index]['name']),
                );
              }),
              onChanged: _onProductChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Số lượng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _quantity.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập số lượng',
              ),
              onChanged: _onQuantityChanged,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Đơn giá:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${_unitPrice.toString()} VND'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thành tiền:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '${_totalPrice.toString()} VND',
                  style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xác nhận đơn hàng'),
                      content: Text(
                        'Sản phẩm: ${_products[_selectedProductIndex]['name']}\n'
                        'Số lượng: $_quantity\n'
                        'Đơn giá: ${_unitPrice.toString()} VND\n'
                        'Thành tiền: ${_totalPrice.toString()} VND',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Tính giá & Xác nhận'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
