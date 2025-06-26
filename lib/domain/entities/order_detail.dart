class OrderDetail {
  final String? id;
  final String orderId;
  final String productVariantId;
  final int quantity;
  final double unitPrice;

  OrderDetail({
    this.id,
    required this.orderId,
    required this.productVariantId,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderDetail.fromMap(Map<String, dynamic> map) => OrderDetail(
        id: map['id'],
        orderId: map['order_id'],
        productVariantId: map['product_variant_id'],
        quantity: map['quantity'],
        unitPrice: (map['unit_price'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'order_id': orderId,
        'product_variant_id': productVariantId,
        'quantity': quantity,
        'unit_price': unitPrice,
      };
}
