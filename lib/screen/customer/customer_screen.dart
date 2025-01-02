import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/controller/customer_controller.dart';
import 'package:pos_system/screen/receipt/Widget/screen_tittle.dart';
import '../../widgets/add_new_button_widget.dart';
import '../../widgets/search_widget.dart';
import 'Widgets/customer_item_widget.dart'; // Import the new widget

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
          ),
        ),
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
            // Screen Title
            const Row(
              children: [
                ScreenTittle(
                  icon: Icon(Icons.people_alt),
                  label: 'Customer',
                ),
              ],
            ),
            // Search and Add New Button
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SearchWidget(),
                  AddNewButtonWidget(
                    onPressed: controller.onAddCustomerPressed,
                    label: 'Add New Customer',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Table Header
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: const Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text('Profile',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Fullname',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Username',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Role',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Create Date',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Create By',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Action',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Customer List
            Expanded(
              child: ListView.builder(
                itemCount: controller.customers.length,
                itemBuilder: (context, index) {
                  final customer = controller.customers[index];
                  return CustomerItemWidget(
                    customer: customer,
                    controller: controller,
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
