// table_model.dart

class TableData {
  final int id;
  final String name;
  final int isDelete;
  final String deleteDate;
  final dynamic deleteBy; // Assuming deleteBy can be null or any type
  final String createdAt;
  final String updatedAt;

  TableData({
    required this.id,
    required this.name,
    required this.isDelete,
    required this.deleteDate,
    required this.deleteBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'],
      name: json['name'],
      isDelete: json['is_delete'],
      deleteDate: json['delete_date'],
      deleteBy: json['delete_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
