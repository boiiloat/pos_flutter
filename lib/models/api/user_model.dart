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
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      profileImage: json['profile_image'],
      roleId: json['role_id'],
      createDate: json['create_date'] != null ? DateTime.parse(json['create_date']) : null,
      createBy: json['create_by'],
      isDelete: json['is_delete'],
      deleteDate: json['delete_date'] != null ? DateTime.parse(json['delete_date']) : null,
      deleteBy: json['delete_by'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}