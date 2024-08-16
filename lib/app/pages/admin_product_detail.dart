import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  double price = 0.0;
  int? selectedVariantIndex;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    print('ProductDetailPage: ${widget.product.toMap()}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.network(
              widget.product.imageUrl,
              width: screenWidth - 32,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Product Name
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: Text(
                      'Giá: ${vietnameseCurrencyFormat(price.toInt().toString())}',
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Variants
            Text(
              'Biến thể:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...widget.product.variants.asMap().entries.map((entry) {
              int index = entry.key;
              var variant = entry.value;
              return Card(
                color:
                    selectedVariantIndex == index ? Colors.blue : Colors.white,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      price = variant.price ?? 0.0;
                      selectedVariantIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (variant.length != null && variant.length != 0.0)
                          Expanded(child: Text('Dài: ${variant.length}m')),
                        if (variant.width != null && variant.width != 0.0)
                          Expanded(child: Text('Rộng: ${variant.width}m')),
                        if (variant.thickness != null &&
                            variant.thickness != 0.0)
                          Expanded(child: Text('Dày: ${variant.thickness}mm')),
                        if (variant.weight != null && variant.weight != 0.0)
                          Expanded(child: Text('Nặng: ${variant.weight}kg')),
                        if (variant.color != null && variant.color!.isNotEmpty)
                          Expanded(child: Text('Màu: ${variant.color}')),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            // Description
            Text(
              'Mô tả sản phẩm:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.product.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Brand
            if (widget.product.brand != null)
              Text(
                'Hãng sản xuất: ${widget.product.brand}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  //function
  //function
  String vietnameseCurrencyFormat(String price) {
    return "${price.replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}." // Add a dot
        )} VND";
  }

  @override
  void initState() {
    super.initState();
    price = widget.product.variants.first.price ?? 0.0;
    selectedVariantIndex = 0;
  }
}
