class Quotation {
  final String? id;
  final DateTime validFrom;
  final String customerId;
  final double? totalAmount;

  Quotation({
    this.id,
    required this.validFrom,
    required this.customerId,
    this.totalAmount,
  });

  factory Quotation.fromMap(Map<String, dynamic> map) => Quotation(
        id: map['id'],
        validFrom: DateTime.parse(map['valid_from']),
        customerId: map['customer_id'],
        totalAmount: map['total_amount'] != null ? (map['total_amount'] as num).toDouble() : null,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'valid_from': validFrom.toIso8601String(),
        'customer_id': customerId,
        'total_amount': totalAmount,
      };
}
