import 'dart:io' as io show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/user_controller.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({Key? key}) : super(key: key);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();

  final _fullnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Uint8List? _webImageBytes;
  String? _webFilename;
  XFile? _pickedImageFile;
  bool _isUploading = false;

  int _selectedRoleId = 2;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
          _pickedImageFile = pickedFile;
        });
        
        final bytes = await pickedFile.readAsBytes();
        
        setState(() {
          _webImageBytes = bytes;
          _webFilename = pickedFile.name;
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() => _isUploading = false);
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New User'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _webImageBytes != null
                          ? MemoryImage(_webImageBytes!)
                          : null,
                      child: _webImageBytes == null
                          ? const Icon(Icons.add_a_photo, size: 30)
                          : null,
                    ),
                    if (_isUploading)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullnameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter full name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedRoleId,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 2, child: Text('Cashier')),
                  DropdownMenuItem(value: 3, child: Text('User')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedRoleId = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        Obx(() => ElevatedButton(
          onPressed: _userController.loading.value
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await _userController.createUser(
                      username: _usernameController.text,
                      password: _passwordController.text,
                      fullname: _fullnameController.text,
                      roleId: _selectedRoleId,
                      profileImage: !kIsWeb && _pickedImageFile != null
                          ? io.File(_pickedImageFile!.path)
                          : null,
                      webImageBytes: kIsWeb ? _webImageBytes : null,
                      webFilename: kIsWeb ? _webFilename : null,
                    );

                    if (success) {
                      Get.back();
                    }
                  }
                },
          child: _userController.loading.value
              ? const CircularProgressIndicator()
              : const Text('Save'),
        )),
      ],
    );
  }
}