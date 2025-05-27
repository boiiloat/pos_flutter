import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_controller.dart';

class UserScreen extends StatelessWidget {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SNACK & RELAX CAFE'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _userController.fetchUsers,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Customer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: Text('Add new user')),
              ],
            ),
          ),
          _buildUserList(),
        ],
      ),
    );
  }

  Widget _buildUserList() {
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

      return Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Profile')),
              DataColumn(label: Text('Fullname')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Created By')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Action')),
            ],
            rows: _userController.users.map((user) {
              return DataRow(
                cells: [
                  DataCell(
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: (user.profileImage != null &&
                              user.profileImage!.isNotEmpty)
                          ? NetworkImage(
                                  'http://127.0.0.1:8000/storage/${user.profileImage}')
                              as ImageProvider
                          : AssetImage("assets/images/logo_image.jpg")
                              as ImageProvider,
                    ),
                  ),
                  DataCell(Text(user.fullname ?? 'N/A')),
                  DataCell(Text(user.username ?? 'N/A')),
                  DataCell(Text(user.createBy ?? 'N/A')),
                  DataCell(
                      Text(user.roleId.toString())), // Convert roleId to string
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Implement delete functionality
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
