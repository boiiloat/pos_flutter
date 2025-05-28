import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_controller.dart';

class UserScreen extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: const Text(
          'SNACK & RELAX CAFE',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _userController.fetchUsers,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSearchBox(),
                _buildAddButton(),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: _boxDecoration(),
                child: _buildUserList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Obx(() {
      if (_userController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_userController.errorMessage.isNotEmpty) {
        return Center(child: Text('Error: ${_userController.errorMessage}'));
      }

      if (_userController.users.isEmpty) {
        return const Center(
          child: Text('No users found', style: TextStyle(color: Colors.grey)),
        );
      }

      return ListView(
        children: [
          _buildHeaderRow(),
          ..._userController.users.map((user) => _buildDataRow(user)).toList(),
        ],
      );
    });
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: const [
          Expanded(
              flex: 2,
              child: Center(child: Text('Profile', style: _headerStyle))),
          Expanded(
              flex: 3,
              child: Center(child: Text('Full Name', style: _headerStyle))),
          Expanded(
              flex: 3,
              child: Center(child: Text('Username', style: _headerStyle))),
          Expanded(
              flex: 2,
              child: Center(child: Text('Created By', style: _headerStyle))),
          Expanded(
              flex: 2, child: Center(child: Text('Role', style: _headerStyle))),
          Expanded(
              flex: 2,
              child: Center(child: Text('Action', style: _headerStyle))),
        ],
      ),
    );
  }

  Widget _buildDataRow(user) {
    final imageProvider =
        (user.profileImage != null && user.profileImage!.isNotEmpty)
            ? NetworkImage('http://127.0.0.1:8000/storage/${user.profileImage}')
            : const AssetImage("assets/images/logo_image.jpg");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: CircleAvatar(
                radius: 24,
                backgroundImage: imageProvider as ImageProvider,
              ),
            ),
          ),
          Expanded(flex: 3, child: Center(child: Text(user.fullname ?? 'N/A'))),
          Expanded(flex: 3, child: Center(child: Text(user.username ?? 'N/A'))),
          Expanded(flex: 2, child: Center(child: Text(user.createBy ?? 'N/A'))),
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(_getRoleName(int.tryParse(user.roleId ?? ''))))),
          Expanded(
            flex: 2,
            child: Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Implement user removal
                  print('Remove pressed for ${user.username}');
                },
                child: const Text(
                  'Remove',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 200,
      height: 40,
      decoration: _boxDecoration(),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          suffixIcon: const Icon(Icons.search, color: Colors.black),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: _inputBorder(),
          enabledBorder: _inputBorder(),
          focusedBorder: _inputBorder(),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      child: Container(
        width: 150,
        height: 38,
        decoration: _boxDecoration(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle),
            SizedBox(width: 10),
            Text('Add Product', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2)),
      ],
      borderRadius: BorderRadius.circular(5),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
  }

  String _getRoleName(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cashier';
      default:
        return 'User';
    }
  }

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 14,
  );
}
