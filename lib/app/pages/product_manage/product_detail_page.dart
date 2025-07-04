import 'package:building_material_retail/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_variant_provider.dart';
import '../../../domain/entities/product.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int? selectedVariantIndex;
  double price = 0.0;

  String vietnameseCurrencyFormat(String price) {
    final priceStr = price;
    return "${priceStr.replaceAllMapped(RegExp(r"(\\d{1,3})(?=(\\d{3})+(?!\\d))"), (Match m) => "${m[1]}." )} VND";
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final variantsAsync = ref.watch(productVariantsProvider(widget.product.id ?? ""));

    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: (selectedVariantIndex == null || variantsAsync is AsyncLoading || variantsAsync.value == null)
              ? null
              : () {
                  final variants = variantsAsync.value!;
                  // Add to cart
                  ref.read(cartProvider.notifier).addItem(
                    widget.product.id ?? widget.product.name,
                    widget.product,
                    variants[selectedVariantIndex!],
                  );
                  Navigator.pop(context);
                },
          child: const Icon(Icons.add_shopping_cart),
        ),
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
              background: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
                ? Image.network(
                    widget.product.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, size: 100, color: Colors.grey)),
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
                        fontWeight: FontWeight.bold),
                    ),
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
                variantsAsync.when(
                  data: (variants) {
                    if (variants.isEmpty) {
                      return const Text('Không có biến thể.');
                    }
                    // Set default price and selection if not set
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (selectedVariantIndex == null && variants.isNotEmpty) {
                        setState(() {
                          price = variants.first.basePrice ?? 0.0;
                          selectedVariantIndex = 0;
                        });
                      }
                    });
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...variants.asMap().entries.map((entry) {
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
                                    price = variant.basePrice ?? 0.0;
                                    selectedVariantIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (variant.size != null && variant.size!.isNotEmpty)
                                        Expanded(child: Text('Kích thước: ${variant.size}')),
                                      if (variant.color != null && variant.color!.isNotEmpty)
                                        Expanded(child: Text('Màu: ${variant.color}')),
                                      Expanded(child: Text('Giá: ${vietnameseCurrencyFormat(variant.basePrice.toInt().toString())}')),
                                      if (variant.technicalSpecs != null && variant.technicalSpecs!.isNotEmpty)
                                        Expanded(child: Text('Thông số: ${variant.technicalSpecs}')),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Lỗi tải biến thể: $e', style: TextStyle(color: Colors.red[700])),
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  'Mô tả sản phẩm:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  widget.product.description ?? '',
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
}
