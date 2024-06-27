import 'package:flutter/material.dart';

class SaleButtomActionWidget extends StatelessWidget {
  final Color color;
  final Icon icon;
  final String label;
   SaleButtomActionWidget({super.key, required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.only(right: 5.0),
       child: Container(
        height: 55,
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: color,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon.icon,color: Colors.white,),
              Text(label, style: TextStyle(fontSize: 13,color: Colors.white)),
            ],
          ),
        ),
           ),
     );
  }
}