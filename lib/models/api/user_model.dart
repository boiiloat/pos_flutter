class User {
  final int id;
  final String fullname;
  final String username;
  final String? profileImage;
  final int roleId;
  final DateTime? createDate;
  final String? createBy;
  final int isDelete;
  final DateTime? deleteDate;
  final String? deleteBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.fullname,
    required this.username,
    this.profileImage,
    required this.roleId,
    this.createDate,
    this.createBy,
    required this.isDelete,
    this.deleteDate,
    this.deleteBy,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _safeParseInt(json['id']),
      fullname: _safeParseString(json['fullname']),
      username: _safeParseString(json['username']),
      profileImage: _safeParseString(json['profile_image']),
      roleId: _safeParseInt(json['role_id']),
      createDate: _safeParseDateTime(json['create_date']),
      createBy: _safeParseString(json['create_by']),
      isDelete: _safeParseInt(json['is_delete']),
      deleteDate: _safeParseDateTime(json['delete_date']),
      deleteBy: _safeParseString(json['delete_by']),
      createdAt: _safeParseDateTime(json['created_at']),
      updatedAt: _safeParseDateTime(json['updated_at']),
    );
  }

  // Helper methods
  static int _safeParseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullname': fullname,
    'username': username,
    'profile_image': profileImage,
    'role_id': roleId,
    'create_date': createDate?.toIso8601String(),
    'create_by': createBy,
    'is_delete': isDelete,
    'delete_date': deleteDate?.toIso8601String(),
    'delete_by': deleteBy,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}