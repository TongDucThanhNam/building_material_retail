import 'package:building_material_retail/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cart_item.dart';
import '../providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final totalAmount = cart.values.fold<double>(
      0.0,
      (sum, item) => sum + (item.variantChosen.price! * item.quantity),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng')),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (ctx, i) => CartItemWidget(
                    cart.values.toList()[i],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng tiền',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        vietnameseCurrencyFormat(
                            totalAmount.toInt().toString()),
                        style: const TextStyle(),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: () {
                        // Xử lý thanh toán
                      },
                      child: const Text('Báo giá'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends ConsumerWidget {
  final CartItem cartItem;

  const CartItemWidget(this.cartItem, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(cartItem.product.name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(cartItem.product.imageUrl),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cartItem.variantChosen.toString()),
          Text(
            'Tổng cộng: ${vietnameseCurrencyFormat((cartItem.variantChosen.price! * cartItem.quantity).toInt().toString())}',
          ),
          Text(
              'Đơn giá: ${vietnameseCurrencyFormat(cartItem.variantChosen.price!.toInt().toString())}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Giảm kích thước hàng ngang
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              // Gọi hàm giảm số lượng từ provider
              ref
                  .watch(cartProvider.notifier)
                  .removeItem(cartItem.product.id ?? cartItem.product.name);
            },
          ),
          Text(cartItem.quantity.toString()), // Hiển thị số lượng
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Gọi hàm thêm số lượng từ provider
              ref.watch(cartProvider.notifier).addItem(
                  cartItem.product.id ?? cartItem.product.name,
                  cartItem.product,
                  cartItem.variantChosen);
            },
          ),
        ],
      ),
    );
  }
}
