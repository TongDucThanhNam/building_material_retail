class User {
  final String? id;
  final String username;
  final String passwordHash;
  final String role;
  final String? storeId;

  User({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
    this.storeId,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        username: map['username'],
        passwordHash: map['password_hash'],
        role: map['role'],
        storeId: map['store_id'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'username': username,
        'password_hash': passwordHash,
        'role': role,
        'store_id': storeId,
      };
}
