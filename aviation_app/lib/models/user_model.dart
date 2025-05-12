class UserModel {
  final int id;
  final String name;
  final String email;
  final String picture;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
  });

  // Convert UserModel to Map (for Firestore or JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'picture': picture,
    };
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      picture: map['picture'] ?? '',
    );
  }

  // Optional: Override toString for easy debugging
  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';
}
