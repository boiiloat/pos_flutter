import 'package:flutter/material.dart';

class CustomerFillWidget extends StatelessWidget {
  final Icon icon;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomerFillWidget({
    super.key,
    required this.icon,
    required this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 40,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 15,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade100),
            borderRadius: BorderRadius.circular(3),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue.shade700,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }
}
