class Customer {
  final String? id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;

  Customer({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
  });

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
        id: map['id'],
        name: map['name'],
        address: map['address'],
        phone: map['phone'],
        email: map['email'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
      };
}
