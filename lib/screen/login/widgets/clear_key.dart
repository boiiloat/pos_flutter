import 'package:flutter/material.dart';

class ClearKeyWidget extends StatelessWidget {
  final Function(String)? onPressed;
  final double height;
  final int flex;
  final VoidCallback? onBackspacePressed;
  final bool disabled;
  final String title;
  final Color btnColor;

  ClearKeyWidget({
    Key? key,
    this.height = 60,
    this.onPressed,
    this.flex = 1,
    this.disabled = false,
    this.onBackspacePressed,
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
            onTap: disabled ? null : onBackspacePressed,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: (disabled || onPressed == null
                        ? Colors.white
                        : Colors.black),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
