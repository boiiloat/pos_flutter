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
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: customer.profile != null
                ? NetworkImage(customer.profile!)
                : null,
            child: customer.profile == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(customer.fullname),
          subtitle: Text(customer.username),
          trailing: Row(
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
    );
  }
}