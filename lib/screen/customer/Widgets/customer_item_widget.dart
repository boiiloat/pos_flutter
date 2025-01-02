import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/customer_controller.dart';
import 'package:pos_system/models/api/customer_model.dart';

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
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              // Profile
              Expanded(
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: customer.profile != null
                        ? NetworkImage(customer.profile!)
                        : null,
                    child: customer.profile == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
              ),
              // Fullname
              Expanded(
                child: Center(
                  child: Text(
                    customer.fullname,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Username
              Expanded(
                child: Center(
                  child: Text(
                    customer.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Role
              Expanded(
                child: Center(
                  child: Text(
                    controller.getRoleName(customer.roleId), // Get role name
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Create Date
              Expanded(
                child: Center(
                  child: Text(
                    customer.createDate ??
                        'No Date Provided', // Display formatted date
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              //create by
              Expanded(
                child: Center(
                  child: Text(
                    customer.createBy.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Action
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Handle edit action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          controller.deleteCustomer(customer.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
