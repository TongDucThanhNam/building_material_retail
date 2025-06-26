class Order {
  final String? id;
  final String storeId;
  final DateTime createdAt;
  final String status;

  Order({
    this.id,
    required this.storeId,
    required this.createdAt,
    required this.status,
  });

  factory Order.fromMap(Map<String, dynamic> map) => Order(
        id: map['id'],
        storeId: map['store_id'],
        createdAt: DateTime.parse(map['created_at']),
        status: map['status'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'store_id': storeId,
        'created_at': createdAt.toIso8601String(),
        'status': status,
      };
}
