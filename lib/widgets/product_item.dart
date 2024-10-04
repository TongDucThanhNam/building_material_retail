import 'package:building_material_retail/app/pages/admin_edit_product.dart';
import 'package:building_material_retail/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../utils/helper.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final WidgetRef ref;

  const ProductItem({super.key, required this.product, required this.ref});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  String priceRange = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          borderOnForeground: true,
          shadowColor: Colors.orange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // shape
          elevation: 5,
          // shadow
          margin: const EdgeInsets.all(10),
          // margin
          child: Row(
            children: [
              //Image
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: widget.product.imageUrl != ""
                    ? Image.network(widget.product.imageUrl,
                        height: 130, width: 120, fit: BoxFit.cover)
                    : const SizedBox(
                        height: 130, width: 120, child: Icon(Icons.image)),
              ),

              const SizedBox(width: 10
                  //Space between image and text

                  ),
              Column(
                children: [
                  //Product name
                  Text(widget.product.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),

                  //Price
                  Text("Giá: ${(priceRange)}",
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),

                  //Unit
                  Text("Đơn vị tính: ${widget.product.type}"),

                  //Brand
                  Text("Thương hiệu: ${widget.product.brand}"),

                  //Day update price
                  const Text("Cập nhật giá: 12/12/2024",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        //More icon

        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //add to cart
                      ListTile(
                        leading: const Icon(Icons.add_shopping_cart),
                        title: const Text("Thêm vào đơn hàng"),
                        onTap: () {
                          //Add to cart
                          widget.ref.read(cartProvider.notifier).addItem(
                              widget.product.id ?? widget.product.name,
                              widget.product,
                              widget.product.variants[0]);

                          //close
                          Navigator.pop(context);
                        },
                      ),

                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Sửa sản phẩm'),
                        onTap: () {
                          // Handle edit action
                          //Route to EditPage
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminEditProduct(
                                      product: widget.product)));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Xoá sản phẩm'),
                        onTap: () {
                          // Handle delete action
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    final prices =
        widget.product.variants.map((variant) => variant.price ?? 0.0).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b).toInt();
    final maxPrice = prices.reduce((a, b) => a > b ? a : b).toInt();

    if (minPrice == maxPrice) {
      priceRange = vietnameseCurrencyFormat(minPrice.toString());
    } else {
      priceRange =
          '${vietnameseCurrencyFormat(minPrice.toString())} - ${vietnameseCurrencyFormat(maxPrice.toString())}';
    }
  }
}
