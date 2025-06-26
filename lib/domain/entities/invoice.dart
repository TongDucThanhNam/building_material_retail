class Invoice {
  final String? id;
  final String orderId;
  final String? series;
  final String? number;
  final DateTime issueDate;
  final double totalAmount;

  Invoice({
    this.id,
    required this.orderId,
    this.series,
    this.number,
    required this.issueDate,
    required this.totalAmount,
  });

  factory Invoice.fromMap(Map<String, dynamic> map) => Invoice(
        id: map['id'],
        orderId: map['order_id'],
        series: map['series'],
        number: map['number'],
        issueDate: DateTime.parse(map['issue_date']),
        totalAmount: (map['total_amount'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'order_id': orderId,
        'series': series,
        'number': number,
        'issue_date': issueDate.toIso8601String(),
        'total_amount': totalAmount,
      };
}
