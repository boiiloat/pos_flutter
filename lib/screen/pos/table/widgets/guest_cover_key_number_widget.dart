import 'package:flutter/material.dart';

class GusetCoverKeyNumberWidget extends StatelessWidget {
  final Function(String)? onPressed;
  final String name;
  final String? title;
  final double height;
  final int flex;
  final Widget? customTitle;
  final bool disabled;
  final Color color;
  const GusetCoverKeyNumberWidget({
    super.key,
    required this.name,
    this.title,
    this.height = 60,
    this.customTitle,
    this.onPressed,
    this.flex = 1,
    this.disabled = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    var title_ = title ?? name;
    return Expanded(
      flex: flex,
      child: Ink(
        padding: const EdgeInsets.all(2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled
                ? null
                : (onPressed == null ? null : () => onPressed!(name)),
            child: Ink(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300),
                color: (onPressed == null || disabled
                    ? Colors.grey[50]
                    : Colors.white),
              ),
              child: customTitle ??
                  Center(
                    child: Text(
                      title_,
                      style: TextStyle(
                        color: onPressed == null || disabled
                            ? Colors.grey[300]!
                            : color,
                        fontSize: 14,
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
