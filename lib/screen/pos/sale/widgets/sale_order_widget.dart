import 'package:flutter/material.dart';

class SaleOrderWidget extends StatelessWidget {
  const SaleOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 5),
              Text('data'),
            ],
          ),
        ),
      ),
    );
  }
}
