import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/auth_service.dart';

import '../../controller/user_controller.dart';
import 'Widgets/user_create_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert'; // For pretty JSON formatting

class UserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data (JSON)'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _userController.fetchUsers,
          ),
        ],
      ),
      body: _buildJsonView(),
    );
  }

  Widget _buildJsonView() {
    return Obx(() {
      if (_userController.loading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (_userController.errorMessage.isNotEmpty) {
        return Center(
            child: Text('Error: ${_userController.errorMessage.value}'));
      }

      if (_userController.users.isEmpty) {
        return Center(child: Text('No users found'));
      }

      // Convert users list to pretty-printed JSON
      final jsonString = JsonEncoder.withIndent('  ')
          .convert(_userController.users.map((user) => user.toJson()).toList());

      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SelectableText(
          jsonString,
          style: TextStyle(fontFamily: 'monospace', fontSize: 14),
        ),
      );
    });
  }
}
