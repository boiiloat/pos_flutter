import 'package:flutter/material.dart';

class SaleItemNoteWidget extends StatelessWidget {
  final String label;
  // ignore: use_key_in_widget_constructors
  const SaleItemNoteWidget({Key? key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:15.0),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
               
              ),
            ],
          ),
        ),
      ),
    );
  }
}
