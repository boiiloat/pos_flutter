import 'package:flutter/material.dart';

import '../../../constans/constan.dart';

class HomeButtonWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color? background;
  final Color? foreground;
  final Color? foregroundIconColor;
  final VoidCallback? onPressed;
  final bool hidden;

  const HomeButtonWidget({
    super.key,
    required this.title,
    required this.iconData,
    this.background,
    this.foreground,
    this.foregroundIconColor,
    this.onPressed,
    this.hidden = false,
  });

  @override
  Widget build(BuildContext context) {
    var background_ = background ?? homeKPIColor;
    var foreground_ = foreground ?? Colors.black;
    var foregroundIconColor_ = foregroundIconColor ?? homeIconColor;
    return hidden
        ? Container(
            padding: EdgeInsets.zero,
            child: const Text(""),
          )
        : Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              color: background_,
              borderRadius: BorderRadius.circular(10.0),
              elevation: 5,
              child: InkWell(
                onTap: onPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: background_,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 90,
                  width: 106,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconData,
                          color: foregroundIconColor_,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          title,
                          style: TextStyle(color: foreground_),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
