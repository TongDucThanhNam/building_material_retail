class Product {
  final String? id;
  final String name;
  final String? description;
  final String? brand; // Optional brand for the product
  final String? imageUrl;
  final String? unit;
  final String? category;
  final double? taxRate;

  Product({
    this.id,
    required this.name,
    this.brand,
    this.description,
    this.imageUrl,
    this.unit,
    this.category,
    this.taxRate,
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        unit: map['unit'],
        category: map['category'],
        taxRate: map['tax_rate'] != null ? (map['tax_rate'] as num).toDouble() : null,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'unit': unit,
        'category': category,
        'tax_rate': taxRate,
      };
}
