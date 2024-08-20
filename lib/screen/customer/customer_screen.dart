// lib/screen/customer_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/customer_controller.dart';
import 'package:pos_system/screen/receipt/Widget/screen_tittle.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CustomerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SNACK & RELAX CAFE',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: appColor,
      ),
      body: Column(
        children: [
          Row(
            children: [
              ScreenTittle(
                icon: Icon(Icons.people_alt),
                label: 'Customer',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.blue.shade700,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16), // Add padding inside the input field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade700),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade700),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade100),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: controller.onAddCustomerPressed,
                  child: Ink(
                    width: 150,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add),
                        SizedBox(width: 10),
                        Text(
                          'Add Customer',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text('Profile',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Fullname',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Username',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Create By',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text('Role',
                                style: TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                      child: Center(
                          child: Text('Action',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.customers.isEmpty) {
                return const Center(child: Text('No customers found'));
              }
              return ListView.builder(
                itemCount: controller.customers.length,
                itemBuilder: (context, index) {
                  var customer = controller.customers[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                                  child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  image: AssetImage(customer.profileImage),
                                  fit: BoxFit.cover),
                            ),
                          ))),
                          Expanded(
                              child: Center(child: Text(customer.fullname))),
                          Expanded(
                              child: Center(child: Text(customer.username))),
                          Expanded(
                              child: Center(child: Text(customer.createdBy))),
                          Expanded(child: Center(child: Text(customer.role))),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
