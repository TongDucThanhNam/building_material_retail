import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/product.dart';
import '../domain/entities/product_variant.dart';

class ProductService {
  ProductService({required this.uid});

  final String uid;
  final supabase = Supabase.instance.client;

  Future<String?> addProduct(Product product) async {
    try {
      final response = await supabase.from('product').insert(product.toMap()).select('id').single();
      return response['id'] as String?;
    } catch (e) {
      print('Error occurred while adding product: $e');
      rethrow;
    }
  }

  Future<void> addProductVariant(ProductVariant variant) async {
    try {
      await supabase.from('product_variant').insert(variant.toMap());
    } catch (e) {
      print('Error occurred while adding product variant: $e');
      rethrow;
    }
  }

  Stream<List<Product>> getProducts() async* {
    try {
      final List data = await supabase.from('product').select().order('name');
      yield data.map((d) => Product.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting products: $e');
      yield [];
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      if (product.id == null) {
        throw ArgumentError('Product id cannot be null for update');
      }
      await supabase.from('product').update(product.toMap()).eq('id', product.id!);
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Stream<List<Product>> searchProduct({String searchTerm = ""}) async* {
    try {
      final List data = await supabase.from('product')
        .select()
        .ilike('name', '%$searchTerm%')
        .order('name');
      yield data.map((d) => Product.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error searching products: $e');
      yield [];
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await supabase.from('product').delete().eq('id', id);
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}
