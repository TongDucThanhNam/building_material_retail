import 'package:building_material_retail/models/variant.dart';

class Product {
  final String? id; //
  final String name; // Sắt vuông 40x80
  final String nameWithoutAccent; // sat vuong 40x80
  final String type; // Sắt
  final String description; // Sắt xây dựng
  final List<String>? searchIndex; // [sat, vuong, 40x80]
  final int price; // 100000
  final String imageUrl; // https://example.com/image.jpg
  final String? brand; // Việt Thành

  final List<Variant> variants; // List of Variant objects

  Product({
    this.id,
    required this.name,
    required this.nameWithoutAccent,
    required this.type,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.searchIndex,
    required this.variants,
    this.brand,
  });

  Product.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? "",
        name = map['name'] ?? "",
        nameWithoutAccent = map['nameWithoutAccent'] ?? "",
        type = map['type'] ?? "",
        description = map['description'] ?? "",
        searchIndex = map['searchIndex'] is List<String>
            ? List<String>.from(map['searchIndex'])
            : null,
        // Remove the unit field from the fromMap constructor
        price = map['price'] ?? 0.0,
        imageUrl = map['imageUrl'] ?? "",
        variants = map['variants'] is List
            ? List<Variant>.from(
                map['variants'].map((item) => Variant.fromMap(item)))
            : [],
        brand = map['brand'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameWithoutAccent': nameWithoutAccent,
      'type': type,
      'description': description,
      'searchIndex': searchIndex,
      // Remove the unit field from the toMap method
      'price': price,
      'imageUrl': imageUrl,
      'brand': brand,
      'variants': variants.map((variant) => variant.toMap()).toList(),
    };
  }
}
