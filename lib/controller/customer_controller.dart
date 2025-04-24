import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pos_system/screen/user/Widgets/customer_add_new_widget.dart';
import '../../models/api/customer_model.dart';
import '../../program.dart';

class CustomerController extends GetxController {
  var customers = <Customer>[].obs; // Observable list of customers
  var selectedRole = 'Admin'.obs; // Observable selected role
  var isLoading = false.obs; // Observable loading state
  final box = GetStorage(); // Local storage for token

  @override
  void onInit() {
    super.onInit();
    fetchCustomers(); // Fetch customers when the controller is initialized
  }

  // Function to format the date
  String formatDayMonthYear(String? date) {
    if (date == null || date.isEmpty) return 'No Date Provided';
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy')
          .format(parsedDate); // Format as day-month-year
    } catch (e) {
      return 'Invalid Date';
    }
  }

  // Get the role name based on roleId
  String getRoleName(int roleId) {
    switch (roleId) {
      case 1:
        return "Admin";
      case 2:
        return "Cashier";
      default:
        return "Unknown";
    }
  }

  // Function to format the date
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'No Date Provided';
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy')
          .format(parsedDate); // Format as day-month-year
    } catch (e) {
      return 'Invalid Date';
    }
  }

  // Fetches customers from the API
  Future<void> fetchCustomers() async {
    isLoading.value = true;

    try {
      String? token = box.read('authToken');
      if (token == null) {
        Program.error('Error', 'No authentication token found.');
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          Program.error('Info', 'No customers found.');
        } else {
          try {
            List<dynamic> data = json.decode(response.body);
            customers.value = data.map((e) => Customer.fromJson(e)).toList();
          } catch (e) {
            Program.error('Error', 'Invalid JSON response from the server.');
          }
        }
      } else {
        // Program.error('Error', 'Failed to fetch customers: ${response.body}');
        print('${response.body}');
      }
    } catch (e) {
      Program.error('Error', 'Error fetching customers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Sets the selected role
  void setSelectedRole(String role) {
    selectedRole.value = role;
  }

  // Deletes a customer by ID
  Future<void> deleteCustomer(int id) async {
    try {
      String? token = box.read('authToken');
      if (token == null) {
        Program.error('Error', 'No authentication token found.');
        return;
      }

      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Remove the customer from the list
        customers.removeWhere((customer) => customer.id == id);
        Program.success('Success', 'Customer deleted successfully.');
      } else {
        Program.error('Error', 'Failed to delete customer: ${response.body}');
      }
    } catch (e) {
      Program.error('Error', 'Error deleting customer: $e');
    }
  }

  void onAddCustomerPressed() {
    Get.dialog(
      Dialog(
        child: CustomerAddNewWidget(),
      ),
    );
  }

  Future<void> createCustomer(Map<String, dynamic> customerData) async {
    try {
      String? token = box.read('authToken');
      if (token == null) {
        Program.error('Error', 'No authentication token found.');
        return;
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(customerData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'User created successfully') {
          await fetchCustomers(); // Refresh the customer list
          Program.success('Success', 'Customer added successfully.');
        } else {
          Program.error('Error', 'Unexpected response: ${response.body}');
        }
      } else {
        Program.error('Error', 'Failed to add customer: ${response.body}');
      }
    } catch (e) {
      Program.error('Error', 'Error adding customer: $e');
    }
  }

// upload image
// Function to upload the image to the backend
  Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://127.0.0.1:8000/api/upload-image'), // Replace with your API endpoint
      );

      // Attach the image file
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'profile',
        stream,
        length,
        filename: imageFile.path.split('/').last,
      );

      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response to get the image path
        var responseData = await response.stream.bytesToString();
        return responseData; // Assuming the server returns the image path
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
