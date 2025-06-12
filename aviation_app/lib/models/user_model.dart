class UserModel {
  final int id;
  final int? airportId;
  final String name;
  final String email;
  final String? gender;
  final String? fcmToken;
  final String? profilePhotoPath;
  final String? avatar;
  final String? lastLoginAt;
  final String? lastLoginIp;
  final String? type;

  UserModel({
    required this.id,
    this.airportId,
    required this.name,
    required this.email,
    this.gender,
    this.fcmToken,
    this.profilePhotoPath,
    this.avatar,
    this.lastLoginAt,
    this.lastLoginIp,
    this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      avatar: map['avatar'],
      airportId: map['airport_id'],
      email: map['email'] ?? '',
      gender: map['gender'],
      fcmToken: map['fcm_token'],
      profilePhotoPath: map['profile_photo_path'],
      lastLoginAt: map['last_login_at'],
      lastLoginIp: map['last_login_ip'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'airport_id': airportId,
      'name': name,
      'email': email,
      'gender': gender,
      'fcm_token': fcmToken,
      'profile_photo_path': profilePhotoPath,
      'avatar': avatar,
      'last_login_at': lastLoginAt,
      'last_login_ip': lastLoginIp,
      'type': type,
    };
  }
}
