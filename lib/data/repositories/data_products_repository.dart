import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

import 'dart:async';

class DataProductsRepository extends ProductsRepository {
  final SupabaseClient supabase;

  DataProductsRepository(this.supabase);

  @override
  Future<Product> getAllProduct(String id) async {
    final data = await supabase.from('products').select().eq('id', id).single();
    return Product.fromMap(data);
  }

  @override
  Future<List<Product>> getProducts() async {
    final List data = await supabase.from('products').select();
    return data.map((doc) => Product.fromMap(doc as Map<String, dynamic>)).toList();
  }
}
