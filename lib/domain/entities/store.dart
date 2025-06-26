class Store {
  final String? id;
  final String name;
  final String? address;
  final String? taxCode;

  Store({
    this.id,
    required this.name,
    this.address,
    this.taxCode,
  });

  factory Store.fromMap(Map<String, dynamic> map) => Store(
        id: map['id'],
        name: map['name'],
        address: map['address'],
        taxCode: map['tax_code'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'address': address,
        'tax_code': taxCode,
      };
}
