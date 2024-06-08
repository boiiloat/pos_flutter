import 'package:flutter/material.dart';

class ClearKeyWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final double height;
  final int flex;
  final bool disabled;
  final String title;
  final Color btnColor;
  const ClearKeyWidget({
    Key? key,
    this.height = 50,
    required this.onPressed,
    this.flex = 1,
    this.disabled = false,
    required this.title,
    required this.btnColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(3),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
