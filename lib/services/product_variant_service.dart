import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/product_variant.dart';

class ProductVariantService {
  final supabase = Supabase.instance.client;

  Future<void> addProductVariant(ProductVariant variant) async {
    try {
      await supabase.from('product_variant').insert(variant.toMap());
    } catch (e) {
      print('Error occurred while adding product variant: $e');
      rethrow;
    }
  }

  Stream<List<ProductVariant>> getProductVariants() async* {
    try {
      final List data = await supabase.from('product_variant').select().order('sku');
      yield data.map((d) => ProductVariant.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting product variants: $e');
      yield [];
    }
  }

  Future<void> updateProductVariant(ProductVariant variant) async {
    try {
      if (variant.id == null) {
        throw ArgumentError('ProductVariant id cannot be null for update');
      }
      await supabase.from('product_variant').update(variant.toMap()).eq('id', variant.id!);
    } catch (e) {
      print('Error updating product variant: $e');
      rethrow;
    }
  }

  Future<void> deleteProductVariant(String id) async {
    try {
      await supabase.from('product_variant').delete().eq('id', id);
    } catch (e) {
      print('Error deleting product variant: $e');
      rethrow;
    }
  }
}
