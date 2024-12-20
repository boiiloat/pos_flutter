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
      body: Obx(() {
        // Show a loading indicator while data is being fetched
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // If no data is available, display a message
        if (controller.customers.isEmpty) {
          return const Center(child: Text('No customers available'));
        }

        return Column(
          children: [
            Row(
              children: [
                ScreenTittle(
                  icon: const Icon(Icons.people_alt),
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
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.blue.shade700,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal:
                                16), // Add padding inside the input field
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text('Profile',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Fullname',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Username',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Create By',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Role',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Action',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: controller.customers.length,
                itemBuilder: (context, index) {
                  final customer = controller.customers[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(customer.profile ?? "null"),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(customer.fullname),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(customer.username),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child:
                                  Text(customer.createBy.toString() ?? "null"),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                  controller.getRoleName(customer.roleId) ??
                                      "null"),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Implement delete functionality
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
