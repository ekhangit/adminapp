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
  final String? position;
  final String? city;
  final String? level;

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
    this.position,
    this.city,
    this.level,
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
      position: map['position']?.toString(),
      city: map['city']?.toString(),
      level: map['level']?.toString(),
    );
  }

  /// Two-letter initials from the name, e.g. "System User 4" -> "SU".
  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final p = parts.first;
      return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// Profile image URL (avatar preferred, else profile photo path). Empty if none.
  String get photoUrl {
    if (avatar?.isNotEmpty ?? false) return avatar!;
    if (profilePhotoPath?.isNotEmpty ?? false) return profilePhotoPath!;
    return '';
  }

  bool get hasPhoto => photoUrl.isNotEmpty;

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
      'position': position,
      'city': city,
      'level': level,
    };
  }
}
