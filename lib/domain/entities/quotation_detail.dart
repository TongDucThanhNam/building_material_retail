class QuotationDetail {
  final String? id;
  final String quotationId;
  final String productVariantId;
  final int quantity;
  final double unitPrice;

  QuotationDetail({
    this.id,
    required this.quotationId,
    required this.productVariantId,
    required this.quantity,
    required this.unitPrice,
  });

  factory QuotationDetail.fromMap(Map<String, dynamic> map) => QuotationDetail(
        id: map['id'],
        quotationId: map['quotation_id'],
        productVariantId: map['product_variant_id'],
        quantity: map['quantity'],
        unitPrice: (map['unit_price'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'quotation_id': quotationId,
        'product_variant_id': productVariantId,
        'quantity': quantity,
        'unit_price': unitPrice,
      };
}
