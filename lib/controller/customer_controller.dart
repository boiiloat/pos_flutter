import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/models/customer_model.dart';
import 'package:pos_system/screen/customer/Widgets/customer_add_new_widget.dart';

class CustomerController extends GetxController {
  // List to hold customer data
  var customers = <Customer>[].obs;
  var selectedRole = 'Admin'.obs; // Default selected role

  @override
  void onInit() {
    fetchCustomers();
    super.onInit();
  }

  void fetchCustomers() {
    // Replace with actual API call
    customers.assignAll([
      Customer(
        profileImage: 'assets/images/fuck.jpg',
        fullname: 'Leam loat',
        username: 'loat',
        createdBy: 'Admin',
        role: 'Admin',
      ),
      Customer(
        profileImage: 'assets/images/on.jpg',
        fullname: 'Som On',
        username: 'bigboss',
        createdBy: 'Admin',
        role: 'Admin',
      ),
      Customer(
        profileImage: 'assets/images/non.jpg',
        fullname: 'Cha nun',
        username: 'cahnon',
        createdBy: 'Leam loat',
        role: 'Admin',
      ),
      Customer(
        profileImage: 'assets/images/youn.jpg',
        fullname: 'Youn chhat',
        username: 'chhatyoun',
        createdBy: 'Admin',
        role: 'Cashier',
      ),
      Customer(
        profileImage: 'assets/images/heng.jpg',
        fullname: 'leab heng',
        username: 'boiheng',
        createdBy: 'Admin',
        role: 'Cashier',
      ),
      Customer(
        profileImage: 'assets/images/ho.jpg',
        fullname: 'Li minho',
        username: 'minho',
        createdBy: 'Leam loat',
        role: 'Cashier',
      ),
      Customer(
        profileImage: 'assets/images/sot.jpg',
        fullname: 'Edward Miller',
        username: 'edwardmiller',
        createdBy: 'Admin',
        role: 'Admin',
      ),
      Customer(
        profileImage: 'assets/images/fake_image8.jpg',
        fullname: 'Fiona Martinez',
        username: 'fionamartinez',
        createdBy: 'Admin',
        role: 'Supervisor',
      ),
      Customer(
        profileImage: 'assets/images/fake_image9.jpg',
        fullname: 'George Lee',
        username: 'georgelee',
        createdBy: 'Admin',
        role: 'Cashier',
      ),
      Customer(
        profileImage: 'assets/images/fake_image10.jpg',
        fullname: 'Hannah Clark',
        username: 'hannahclark',
        createdBy: 'Admin',
        role: 'Manager',
      ),
    ]);
  }

  void setSelectedRole(String role) {
    selectedRole.value = role;
  }

  void onAddCustomerPressed() {
    Get.dialog(
      Dialog(
        child: CustomerAddNewWidget(),
      ),
    );
  }
}
