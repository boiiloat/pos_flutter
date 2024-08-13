// lib/models/customer.dart
class Customer {
  final String profileImage;
  final String fullname;
  final String username;
  final String createdBy;
  final String role;

  Customer({
    required this.profileImage,
    required this.fullname,
    required this.username,
    required this.createdBy,
    required this.role,
  });
}
