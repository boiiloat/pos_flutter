class Customer {
  final int id;
  final String fullname;
  final String username;
  final String? profile;
  final int roleId;
  final String createBy;
  final String? createDate;
  final int isDelete;
  final String? deleteDate;
  final String? createdAt;
  final String? updatedAt;

  Customer({
    required this.id,
    required this.fullname,
    required this.username,
    this.profile,
    required this.roleId,
    required this.createBy,
    this.createDate,
    required this.isDelete,
    this.deleteDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      username: json['username'] ?? '',
      profile: json['profile'],
      roleId: json['role_id'] ?? 0,
      createBy: json['create_by'] ?? 0,
      createDate: json['create_date'],
      isDelete: json['is_delete'] ?? 0,
      deleteDate: json['delete_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'profile': profile,
      'role_id': roleId,
      'create_by': createBy,
      'create_date': createDate,
      'is_delete': isDelete,
      'delete_date': deleteDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
