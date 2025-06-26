class Inventory {
  final String? id;
  final String productVariantId;
  final String storeId;
  final int quantity;

  Inventory({
    this.id,
    required this.productVariantId,
    required this.storeId,
    required this.quantity,
  });

  factory Inventory.fromMap(Map<String, dynamic> map) => Inventory(
        id: map['id'],
        productVariantId: map['product_variant_id'],
        storeId: map['store_id'],
        quantity: map['quantity'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'product_variant_id': productVariantId,
        'store_id': storeId,
        'quantity': quantity,
      };
}
