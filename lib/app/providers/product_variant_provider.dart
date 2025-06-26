import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_variant.dart';
import '../../services/product_variant_service.dart';

final productVariantsProvider = StreamProvider.family<List<ProductVariant>, String>((ref, productId) {
  final service = ProductVariantService();
  return service.getProductVariants().map((variants) =>
    variants.where((v) => v.productId == productId).toList()
  );
});
