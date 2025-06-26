class OrderStatusHistory {
  final String? id;
  final String orderId;
  final String status;
  final DateTime changedAt;

  OrderStatusHistory({
    this.id,
    required this.orderId,
    required this.status,
    required this.changedAt,
  });

  factory OrderStatusHistory.fromMap(Map<String, dynamic> map) => OrderStatusHistory(
        id: map['id'],
        orderId: map['order_id'],
        status: map['status'],
        changedAt: DateTime.parse(map['changed_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'order_id': orderId,
        'status': status,
        'changed_at': changedAt.toIso8601String(),
      };
}
