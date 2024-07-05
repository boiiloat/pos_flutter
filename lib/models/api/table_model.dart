// models/api/table_model.dart
class TableData {
  int id;
  String name;
  int seats; // Change 'seat' to 'seats' to match API response
  int available; // Change 'isAvailable' to 'available' to match API response

  TableData({
    required this.id,
    required this.name,
    required this.seats,
    required this.available,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'],
      name: json['name'],
      seats: json['seats'], // Update field name to 'seats'
      available: json['available'], // Update field name to 'available'
    );
  }
}
