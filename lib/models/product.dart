class Product {
  // final String id;
  final String name;
  final String nameWithoutAccent;
  final String type;
  final String description;

  //searchIndex
  final List<String>? searchIndex;

  // Remove the unit field
  final int price;
  final String imageUrl;
  final String? brand;
  final Map<String, dynamic>? specifications;
  final List<String>? tags;

  Product({
    // required this.id,
    required this.name,
    required this.nameWithoutAccent,
    required this.type,
    required this.description,
    // Remove the unit field from the constructor
    required this.price,
    required this.imageUrl,
    required this.searchIndex,
    this.brand,
    this.specifications,
    this.tags,
  });

  Product.fromMap(Map<String, dynamic> map)
      :
        // id = map['id'] ?? "",
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
        brand = map['brand'],
        specifications = map['specifications'],
        tags =
            map['tags'] is List<String> ? List<String>.from(map['tags']) : null;

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'nameWithoutAccent': nameWithoutAccent,
      'type': type,
      'description': description,
      'searchIndex': searchIndex,
      // Remove the unit field from the toMap method
      'price': price,
      'imageUrl': imageUrl,
      'brand': brand,
      'specifications': specifications,
      'tags': tags,
    };
  }
}
