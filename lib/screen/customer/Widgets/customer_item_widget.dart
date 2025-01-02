// widgets/customer_item_widget.dart
import 'package:flutter/material.dart';
import 'package:pos_system/controller/customer_controller.dart';

import '../../../models/api/customer_model.dart'; // Assuming you have a Customer model

class CustomerItemWidget extends StatelessWidget {
  final Customer customer;
  final CustomerController controller;

  const CustomerItemWidget({
    super.key,
    required this.customer,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            // Profile Image
            Expanded(
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                  image:
                      customer.profile != null && customer.profile!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(customer.profile!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                  'assets/images/profile_placeholder.png'),
                            ),
                ),
              ),
            ),
            // Fullname
            Expanded(
              child: Center(
                child: Text(customer.fullname),
              ),
            ),
            // Username
            Expanded(
              child: Center(
                child: Text(customer.username),
              ),
            ),
            // Create By
            Expanded(
              child: Center(
                child: Text(customer.createBy.toString() ?? "null"),
              ),
            ),
            // Role
            Expanded(
              child: Center(
                child: Text(controller.getRoleName(customer.roleId) ?? "null"),
              ),
            ),
            // Delete Button
            Expanded(
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deleteCustomer(customer.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
