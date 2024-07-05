class Table {
  int id;
  String name;
  int seats;
  bool available;

  Table({required this.id, required this.name, required this.seats, required this.available,});

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      name: json['name'],
      seats: json['seats'],
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'seats': seats,
      'available': available,
    };
  }
}
