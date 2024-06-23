import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../models/product.dart';

class FirestoreService {
  FirestoreService({required this.uid});

  final String uid;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    try {
      // Generate a new document reference with an auto-generated ID
      final docRef = firestore.collection("products").doc();

      // Create a new product in the database with the generated ID
      await docRef.set({
        ...product.toMap(),
        'id': docRef.id,
      });
    } catch (e) {
      // Handle any errors that occur during the transaction
      print('Error occurred while adding product: $e');
      throw e;
    }
  }

  // Inside Firestore service
  Stream<List<Product>> getProducts({String searchTerm = ""}) {
    print("Getting products");

    return firestore
        .collection("products") // gets collection
        .orderBy("name") // order by name
        .snapshots() // gets snapshots, loop through
        .map((snapshot) => snapshot.docs.map((doc) {
              // loop through docs
              final d = doc.data(); // for each doc get the data

              print("Data: $d");

              return Product.fromMap(d); // convert into a map
            }).toList()); // build a list out of the products mapping
  }

  Future<void> updateProductImageUrl(String id, String imageUrl) async {
    return await firestore
        .collection("products")
        .doc(id)
        .update({'imageUrl': imageUrl});
  }

  //Search by keyword
  Stream<List<Product>> searchProduct({String searchTerm = ""}) {
    //search without accent
    final nameWithoutAccent = removeDiacritics(searchTerm).toLowerCase();

    //Split the name into words
    final words = nameWithoutAccent.split(" ");
    List<String> searchIndex = [];
    searchIndex.addAll(words);

    print("Getting products");
    print(words);

    Query query = firestore.collection("products").orderBy("name");

    if (searchTerm.isNotEmpty) {
      query = query.where("searchIndex", arrayContainsAny: searchIndex);
    }

    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final d = doc.data();
          print("Data: $d");
          return Product.fromMap(d as Map<String, dynamic>);
        }).toList());
  }

  // Delete
  Future<void> deleteProduct(String id) async {
    return await firestore.collection("products").doc(id).delete();
  }
}
