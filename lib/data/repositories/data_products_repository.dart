import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

import 'dart:async';

class DataProductsRepository extends ProductsRepository {
  final FirebaseFirestore firestore;

  DataProductsRepository(this.firestore);

  @override
  Future<Product> getAllProduct(String id) async {
    final snapshot = await firestore.collection('products').doc(id).get();
    return Product.fromMap(snapshot.data()!);
  }

  @override
  Future<List<Product>> getProducts() async {
    final snapshot = await firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }
}
