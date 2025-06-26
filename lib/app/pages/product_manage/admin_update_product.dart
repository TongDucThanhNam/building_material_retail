import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/product_variant.dart';
import '../../providers/providers.dart';
import '../../../services/product_variant_service.dart';

final productsListProvider = FutureProvider<List<Product>>((ref) async {
  final db = ref.read(databaseProvider);
  if (db == null) return [];
  final products = await db.getProducts().first;
  return products;
});

final productVariantsListProvider = FutureProvider<List<ProductVariant>>((ref) async {
  final variantService = ProductVariantService();
  final variants = await variantService.getProductVariants().first;
  return variants;
});

class UpdateProductPage extends ConsumerStatefulWidget {
  const UpdateProductPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends ConsumerState<UpdateProductPage> {
  Product? selectedProduct;
  ProductVariant? selectedVariant;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    colorController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  void fillControllers(Product product, ProductVariant? variant) {
    nameController.text = product.name;
    if (variant != null) {
      priceController.text = variant.basePrice.toString();
      colorController.text = variant.color ?? '';
      sizeController.text = variant.size ?? '';
    } else {
      priceController.text = '';
      colorController.text = '';
      sizeController.text = '';
    }
  }

  Future<void> updateProductAndVariant() async {
    if (selectedProduct == null) return;
    final productService = ref.read(databaseProvider);
    final variantService = ProductVariantService();
    if (productService == null) return;
    final updatedProduct = Product(
      id: selectedProduct!.id,
      name: nameController.text,
      unit: selectedProduct!.unit,
      category: selectedProduct!.category,
      taxRate: selectedProduct!.taxRate,
    );
    await productService.updateProduct(updatedProduct);
    if (selectedVariant != null) {
      final updatedVariant = ProductVariant(
        id: selectedVariant!.id,
        productId: selectedVariant!.productId,
        sku: selectedVariant!.sku,
        basePrice: double.tryParse(priceController.text) ?? 0.0,
        size: sizeController.text.isNotEmpty ? sizeController.text : null,
        color: colorController.text.isNotEmpty ? colorController.text : null,
        technicalSpecs: selectedVariant!.technicalSpecs,
      );
      await variantService.updateProductVariant(updatedVariant);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cập nhật thành công!')),
    );
    setState(() {
      selectedProduct = null;
      selectedVariant = null;
    });
    ref.invalidate(productsListProvider);
    ref.invalidate(productVariantsListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productsListProvider);
    final variantAsync = ref.watch(productVariantsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (selectedProduct == null) ...[
              const Text('Chọn sản phẩm để cập nhật:', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: productAsync.when(
                  data: (products) => ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, idx) {
                      final product = products[idx];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(product.category ?? ''),
                        onTap: () {
                          final variants = variantAsync.asData?.value.where((v) => v.productId == product.id).toList() ?? [];
                          setState(() {
                            selectedProduct = product;
                            selectedVariant = variants.isNotEmpty ? variants.first : null;
                          });
                          fillControllers(product, variants.isNotEmpty ? variants.first : null);
                        },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Lỗi tải sản phẩm: $e')),
                ),
              ),
            ] else ...[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Màu sắc'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: sizeController,
                decoration: const InputDecoration(labelText: 'Kích thước'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: updateProductAndVariant,
                    child: const Text('Lưu thay đổi'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedProduct = null;
                        selectedVariant = null;
                      });
                    },
                    child: const Text('Huỷ'),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
