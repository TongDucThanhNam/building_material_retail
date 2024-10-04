import 'package:building_material_retail/models/variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product.dart';
import '../../utils/helper.dart';
import '../providers.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  Variant? variantSelected;
  double price = 0.0;
  int? selectedVariantIndex;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    print('ProductDetailPage: ${widget.product.toMap()}');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          //add
          ref.read(cartProvider.notifier).addItem(
                widget.product.id ?? widget.product.name,
                widget.product,
                widget.product.variants[selectedVariantIndex!],
              ),

          //pop
          Navigator.pop(context)
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: screenHeight * 0.3,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.product.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              background: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Product Name
                    Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                        'Giá: ${vietnameseCurrencyFormat(price.toInt().toString())}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 16),

                // Brand
                if (widget.product.brand != null)
                  Text(
                    'Hãng sản xuất: ${widget.product.brand}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                const SizedBox(height: 8),

                // Variants
                Text(
                  'Biến thể:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  // height: screenHeight * 0.2,
                  // width: screenWidth,
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...widget.product.variants.asMap().entries.map((entry) {
                          int index = entry.key;
                          var variant = entry.value;
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: selectedVariantIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              backgroundColor: selectedVariantIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                            ),
                            onPressed: () {
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
                                  if (variant.length != null &&
                                      variant.length != 0.0)
                                    Expanded(
                                        child: Text('Dài: ${variant.length}m')),
                                  if (variant.width != null &&
                                      variant.width != 0.0)
                                    Expanded(
                                        child: Text("Rộng: ${variant.width}m")),
                                  if (variant.thickness != null &&
                                      variant.thickness != 0.0)
                                    Expanded(
                                        child: Text(
                                            'Dày: ${variant.thickness}mm')),
                                  if (variant.weight != null &&
                                      variant.weight != 0.0)
                                    Expanded(
                                        child:
                                            Text('Nặng: ${variant.weight}kg')),
                                  if (variant.color != null &&
                                      variant.color!.isNotEmpty)
                                    Expanded(
                                        child: Text('Màu: ${variant.color}')),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

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
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //function
  //function

  @override
  void initState() {
    super.initState();
    price = widget.product.variants.first.price ?? 0.0;
    selectedVariantIndex = 0;
  }
}
