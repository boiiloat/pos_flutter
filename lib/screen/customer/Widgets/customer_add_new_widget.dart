import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/customer_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/customer/Widgets/customer_fill_widget.dart';

class CustomerAddNewWidget extends StatefulWidget {
  const CustomerAddNewWidget({super.key});
  @override
  State<CustomerAddNewWidget> createState() => _CustomerAddNewWidgetState();
}

class _CustomerAddNewWidgetState extends State<CustomerAddNewWidget> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  int _selectedRoleId = 1; // Default role is Admin (role_id = 1)
  String? _imageUrl; // Optional image URL

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CustomerController>();

    return Container(
      width: 450,
      height: 500,
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    'ADD NEW CUSTOMER',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Profile Image
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: NetworkImage(
                            _imageUrl ??
                                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Upload Image Button
                    InkWell(
                      onTap: () {
                        // TODO: Implement image upload logic
                        Program.success("Info",
                            "Image upload feature not implemented yet.");
                      },
                      child: Container(
                        height: 25,
                        width: 84,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            'Upload Image',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Full Name Field
                    CustomerFillWidget(
                      icon: Icon(Icons.home),
                      hintText: 'Full Name',
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Username Field
                    CustomerFillWidget(
                      icon: Icon(Icons.person_2_outlined),
                      hintText: 'Username',
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Password Field
                    CustomerFillWidget(
                      icon: Icon(Icons.key),
                      hintText: 'Password',
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    // Role Dropdown
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: DropdownButtonFormField<int>(
                        value: _selectedRoleId,
                        decoration: InputDecoration(
                          hintText: 'Role',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade100),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue.shade700,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Admin'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Cashier'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRoleId = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Submit Button
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final newCustomer = {
                            'fullname': _fullNameController.text,
                            'username': _usernameController.text,
                            'password': _passwordController.text,
                            'role_id': _selectedRoleId,
                            'profile': _imageUrl,
                          };

                          // Close the dialog immediately
                          Get.back();

                          // Call the API to create the customer
                          try {
                            await controller.createCustomer(newCustomer);
                            // Optionally, show a success message
                            Program.success(
                                "Success", "Customer added successfully!");
                          } catch (e) {
                            // Show an error message if the API call fails
                            Program.error(
                                "Error", "Failed to add customer: $e");
                          }
                        } else {
                          // Handle form validation failure (optional)
                          print("Form validation failed.");
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
