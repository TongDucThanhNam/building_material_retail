import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

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
    //function
    String vietnameseCurrencyFormat(String price) {
      return "${price.replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}." // Add a dot
          )} VND";
    }

    return Card(
        borderOnForeground: true,
        shadowColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                  : Container(
                      height: 130, width: 120, child: const Icon(Icons.image)),
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
                Text("Giá: ${vietnameseCurrencyFormat(priceRange)}",
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),

                //Unit
                Text("Đơn vị tính: ${widget.product.type}"),

                //Brand
                Text("Thương hiệu: ${widget.product.brand}"),

                //Day update price
                const Text("Cập nhật giá: 12/12/2021",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ));
  }

  //function
  String vietnameseCurrencyFormat(String price) {
    return "${price.replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}." // Add a dot
        )}";
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
