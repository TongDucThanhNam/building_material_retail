import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:building_material_retail/app/pages/product_manage/admin_add_product.dart';
import 'package:building_material_retail/app/pages/product_manage/admin_update_product.dart';
import 'package:building_material_retail/app/pages/product_manage/calculate_order_price.dart';
import '../../providers/providers.dart';
import 'edit_product.dart';

class ProductManagement extends ConsumerWidget {
  final double screenWidth;
  final double screenHeight;
  final double padding;
  final Provider<TextEditingController> searchControllerProvider;

  const ProductManagement({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.padding,
    required this.searchControllerProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(
        children: [
          //Search bar
          SearchBar(
              onSubmitted: (value) {
                ref.read(searchControllerProvider).text = value;
              },
              leading: const Icon(Icons.search),
              controller: ref.read(searchControllerProvider),
              hintText: "Tìm kiếm sản phẩm",
              trailing: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    ref.read(searchControllerProvider).clear();
                  },
                ),
              ]),
          const SizedBox(height: 10),
          // 1st row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add Product
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminAddProductPage(),
                      ));
                },
                child: Card(
                  color: Colors.blue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.5 - padding * 2,
                    height: screenHeight * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        Text(
                          'Thêm vật tư',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Edit Product
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProductPage(),
                      ));
                },
                child: Card(
                  color: Colors.green,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.5 - padding * 2,
                    height: screenHeight * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit),
                        Text('Cập nhật giá',
                            style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 2nd row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProductPage(),
                      ));
                },
                child: Card(
                  color: Colors.red,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.5 - padding * 2,
                    height: screenHeight * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit),
                        Text('Thay đổi thông tin',
                            style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalculateOrderPricePage(),
                      ));
                },
                child: Card(
                  color: Colors.orange,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.5 - padding * 2,
                    height: screenHeight * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info),
                        Text('Tính đơn hàng',
                            style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
