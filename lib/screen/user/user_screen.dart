import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../controller/user_controller.dart';
import '../../models/api/user_model.dart';
import '../../utils/constants.dart';

class UserScreen extends StatelessWidget {
  final UserController controller = Get.put(UserController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: const Text('USERS', style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.fetchUsers();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User List',
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
                if (controller.isAdmin.value) _buildAddButton(),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: _boxDecoration(),
                child: Obx(() {
                  if (controller.loading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                        child: Text('Error: ${controller.errorMessage.value}'));
                  }
                  if (controller.filteredUsers.isEmpty) {
                    return Center(
                      child: Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'No matching users found'
                            : 'No users found',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        child: _buildHeaderRow(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = controller.filteredUsers[index];
                            return _buildDataRow(user);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 200,
      height: 40,
      decoration: _boxDecoration(),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.searchQuery.value = '';
                    controller.filterUsers();
                  },
                )
              : const Icon(Icons.search, color: Colors.black)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: _inputBorder(),
          enabledBorder: _inputBorder(),
          focusedBorder: _inputBorder(),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 150,
      height: 40,
      decoration: _boxDecoration(),
      child: InkWell(
        onTap: () => _showAddUserDialog(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle),
            SizedBox(width: 8),
            Text('Add User'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: const [
        Expanded(
            flex: 2, child: Center(child: Text('Image', style: _headerStyle))),
        Expanded(
            flex: 3,
            child: Center(child: Text('Full Name', style: _headerStyle))),
        Expanded(
            flex: 3,
            child: Center(child: Text('Username', style: _headerStyle))),
        Expanded(
            flex: 2, child: Center(child: Text('Role', style: _headerStyle))),
        Expanded(
            flex: 2,
            child: Center(child: Text('Created By', style: _headerStyle))),
        Expanded(
            flex: 2, child: Center(child: Text('Action', style: _headerStyle))),
      ],
    );
  }

  Widget _buildDataRow(User user) {
    final imageUrl =
        (user.profileImage != null && user.profileImage!.isNotEmpty)
            ? 'http://localhost:8000/storage/${user.profileImage}'
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: CircleAvatar(
                radius: 24,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/images/logo_image.jpg')
                        as ImageProvider,
              ),
            ),
          ),
          Expanded(flex: 3, child: Center(child: Text(user.fullname ?? 'N/A'))),
          Expanded(flex: 3, child: Center(child: Text(user.username ?? 'N/A'))),
          Expanded(
              flex: 2, child: Center(child: Text(user.roleName ?? 'Unknown'))),
          Expanded(flex: 2, child: Center(child: Text(user.createBy ?? 'N/A'))),
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isAdmin.value)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditUserDialog(user),
                    ),
                  if (controller.isAdmin.value)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(user.id),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    usernameController.clear();
    fullnameController.clear();
    passwordController.clear();
    controller.selectedImage.value = null;
    controller.selectedRoleId.value = 0;

    Get.defaultDialog(
      title: 'Add New User',
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fullnameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  value: controller.selectedRoleId.value == 0
                      ? null
                      : controller.selectedRoleId.value,
                  items: controller.roles.map<DropdownMenuItem<int>>((role) {
                    return DropdownMenuItem<int>(
                      value: role['id'] as int,
                      child: Text(role['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedRoleId.value = value ?? 0;
                  },
                  validator: (value) =>
                      value == null ? 'Please select a role' : null,
                )),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (usernameController.text.isEmpty ||
              fullnameController.text.isEmpty ||
              passwordController.text.isEmpty ||
              controller.selectedRoleId.value == 0) {
            Get.snackbar('Error', 'Please fill all fields');
            return;
          }

          final success = await controller.createUser(
            username: usernameController.text,
            password: passwordController.text,
            fullname: fullnameController.text,
            roleId: controller.selectedRoleId.value,
            imageInfo: controller.selectedImage.value,
          );

          if (success) {
            Get.back();
          }
        },
        child: const Text('Save'),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text('Cancel'),
      ),
    );
  }

  void _showEditUserDialog(User user) {
    usernameController.text = user.username ?? '';
    fullnameController.text = user.fullname ?? '';
    passwordController.clear();
    controller.selectedRoleId.value = user.roleId;
    controller.selectedImage.value = null;

    Get.defaultDialog(
      title: 'Edit User',
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePicker(currentImageUrl: user.profileImage),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fullnameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'New Password (leave empty to keep current)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  value: controller.selectedRoleId.value,
                  items: controller.roles.map<DropdownMenuItem<int>>((role) {
                    return DropdownMenuItem<int>(
                      value: role['id'] as int,
                      child: Text(role['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedRoleId.value = value ?? 0;
                  },
                )),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (usernameController.text.isEmpty ||
              fullnameController.text.isEmpty ||
              controller.selectedRoleId.value == 0) {
            Get.snackbar('Error', 'Please fill all required fields');
            return;
          }

          final success = await controller.updateUser(
            userId: user.id,
            username: usernameController.text,
            fullname: fullnameController.text,
            roleId: controller.selectedRoleId.value,
            password: passwordController.text.isNotEmpty
                ? passwordController.text
                : null,
            imageInfo: controller.selectedImage.value,
          );

          if (success) {
            Get.back();
          }
        },
        child: const Text('Update'),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text('Cancel'),
      ),
    );
  }

  Widget _buildImagePicker({String? currentImageUrl}) {
    return Column(
      children: [
        Obx(() {
          if (controller.selectedImage.value != null) {
            return Image.memory(
              controller.selectedImage.value!.bytes,
              height: 100,
              fit: BoxFit.cover,
            );
          }
          return currentImageUrl != null && currentImageUrl.isNotEmpty
              ? Image.network(
                  'http://localhost:8000/storage/$currentImageUrl',
                  height: 100,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.person, size: 50),
                );
        }),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final image = await ImagePickerWeb.getImageAsBytes();
            if (image != null) {
              final filename =
                  'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
              controller.selectedImage.value = WebImageInfo(
                bytes: image,
                filename: filename,
              );
            }
          },
          child: const Text('Select Image'),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(int userId) {
    Get.defaultDialog(
      title: 'Confirm Delete',
      middleText: 'Are you sure you want to delete this user?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        final success = await controller.deleteUser(userId);
        if (success) {
          Get.back();
        }
      },
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 2),
        )
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

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 14,
  );
}
