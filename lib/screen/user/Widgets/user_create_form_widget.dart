import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/user_controller.dart';
class CreateUserForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _roleIdController = TextEditingController(text: '2');

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _fullnameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            DropdownButtonFormField<int>(
              value: int.tryParse(_roleIdController.text) ?? 2,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Admin')),
                DropdownMenuItem(value: 2, child: Text('User')),
              ],
              onChanged: (value) => _roleIdController.text = value.toString(),
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 20),
            Obx(() => userController.loading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await userController.createUser(
                          username: _usernameController.text,
                          password: _passwordController.text,
                          fullname: _fullnameController.text,
                          roleId: int.tryParse(_roleIdController.text) ?? 2,
                        );
                      }
                    },
                    child: Text('Create User'),
                  )),
            Obx(() => userController.errorMessage.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      userController.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox()),
          ],
        ),
      ),
    );
  }
}