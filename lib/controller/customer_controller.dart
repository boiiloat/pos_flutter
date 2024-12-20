import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/screen/customer/Widgets/customer_add_new_widget.dart';
import '../../models/api/customer_model.dart';
import '../../program.dart';

class CustomerController extends GetxController {
  var customers = <Customer>[].obs; // List of customers
  var selectedRole = 'Admin'.obs; // Default selected role
  var isLoading = false.obs; // Loading indicator for API calls
  final box = GetStorage(); // To access locally stored token

  // Get the role name based on roleId
  String getRoleName(int roleId) {
    if (roleId == 1) {
      return "Admin"; // Role 1 = Admin
    } else if (roleId == 2) {
      return "Cashier"; // Role 2 = Cashier
    } else {
      return "Unknown"; // Return "Unknown" for any other roleId
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCustomers(); // Fetch customers when the controller is initialized
  }

  // Fetches customers from the API and updates the list
  Future<void> fetchCustomers() async {
    isLoading.value = true;

    try {
      // Retrieve the token from GetStorage
      String? token = box.read('authToken');
      if (token == null) {
        // Handle case where the token is missing
        Program.error('Error', 'No authentication token found.');
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/users'),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in headers
          'Content-Type': 'application/json',
        },
      );

      // Check for a valid response
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          // Handle empty data
          Program.error('Error', 'No customers found.');
        } else {
          // Map the response data to the customer model
          customers.value = data.map((e) => Customer.fromJson(e)).toList();
          // Print all user data to the console for debugging
          for (var customer in customers) {
            print('Customer Data: ${customer.toJson()}');
          }
        }
      } else {
        Program.error('Error', 'Failed to fetch customers: ${response.body}');
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

  // Opens a dialog to add a new customer
  void onAddCustomerPressed() {
    Get.dialog(
      Dialog(
        child: CustomerAddNewWidget(),
      ),
    );
  }
}
