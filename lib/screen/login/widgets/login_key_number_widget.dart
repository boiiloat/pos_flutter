import 'package:flutter/material.dart';

class LoginKeyNumberWidget extends StatelessWidget {
  final Function(String)? onPressed;
  final String name;
  final String? title;
  final double height;
  final int flex;
  final Widget? customTitle;
  final bool disabled;

  const LoginKeyNumberWidget({
    super.key,
    required this.name,
    this.title,
    this.height = 60,
    this.customTitle,
    this.onPressed,
    this.flex = 1,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    var title_ = title ?? name;
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(3),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled
                ? null
                : (onPressed == null ? null : () => onPressed!(name)),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: (onPressed == null || disabled
                    ? Colors.grey[100]
                    : Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: customTitle ??
                  Center(
                    child: Text(
                      title_,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        // fontWeight: FontWeight.bold,
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
