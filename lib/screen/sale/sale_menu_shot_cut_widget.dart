import 'package:flutter/material.dart';


class SaleMenuShotCutWidget extends StatelessWidget {
  // final Map<String, dynamic> menu;
  // final Function(Map<String, dynamic>)? onPressed;

  const SaleMenuShotCutWidget({
    super.key,
    // required this.menu,
    // required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = 30.0;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 40,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Text(
              'fuck me',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
