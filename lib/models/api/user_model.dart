class User {
  final int id;
  final String fullname;
  final String username;
  final String? profileImage;
  final int roleId;
  final String? roleName;
  final DateTime? createDate;
  final String? createBy;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.fullname,
    required this.username,
    this.profileImage,
    required this.roleId,
    this.roleName,
    this.createDate,
    this.createBy,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _safeParseInt(json['id']),
      fullname: _safeParseString(json['fullname']),
      username: _safeParseString(json['username']),
      profileImage: _safeParseString(json['profile_image']),
      roleId: json['role'] != null 
          ? _safeParseInt(json['role']['id'])
          : _safeParseInt(json['role_id']),
      roleName: json['role'] != null
          ? _safeParseString(json['role']['name'])
          : _safeParseString(json['role_name']),
      createDate: _safeParseDateTime(json['create_date']),
      createBy: _safeParseString(json['create_by']),
      updatedAt: _safeParseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'username': username,
        'profile_image': profileImage,
        'role_id': roleId,
        'role_name': roleName,
        'create_date': createDate?.toIso8601String(),
        'create_by': createBy,
        'updated_at': updatedAt?.toIso8601String(),
      };

  // Helper methods
  static int _safeParseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String _safeParseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static DateTime? _safeParseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}