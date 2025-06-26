class ProductVariant {
  final String? id;
  final String productId;
  final String? size;
  final String? color;
  final String sku;
  final double basePrice;
  final Map<String, dynamic>? technicalSpecs;

  ProductVariant({
    this.id,
    required this.productId,
    this.size,
    this.color,
    required this.sku,
    required this.basePrice,
    this.technicalSpecs,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) => ProductVariant(
        id: map['id'],
        productId: map['product_id'],
        size: map['size'],
        color: map['color'],
        sku: map['sku'],
        basePrice: (map['base_price'] as num).toDouble(),
        technicalSpecs: map['technical_specs'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'product_id': productId,
        'size': size,
        'color': color,
        'sku': sku,
        'base_price': basePrice,
        'technical_specs': technicalSpecs,
      };
}
