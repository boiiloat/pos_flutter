import 'package:flutter/material.dart';

import '../../utils/constants.dart';


class TextIconLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final bool isSuffixIcon;
  final IconData? icon;
  final String title;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  const TextIconLoadingWidget({
    super.key,
    required this.title,
    required this.isLoading,
    this.icon,
    this.isSuffixIcon = false,
    this.color,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = fontSize + 10;
    final loadingIconSize = fontSize + 4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: isLoading
          ? [
              isSuffixIcon
                  ? Container()
                  : SizedBox(
                      width: loadingIconSize,
                      height: loadingIconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: color,
                      ),
                    ),
              isSuffixIcon ? Container() : const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  color: color ?? textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
              !isSuffixIcon ? Container() : const SizedBox(width: 10),
              !isSuffixIcon
                  ? Container()
                  : SizedBox(
                      width: loadingIconSize,
                      height: loadingIconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: color,
                      ),
                    ),
            ]
          : [
              isSuffixIcon
                  ? Container()
                  : icon == null
                      ? Container()
                      : Icon(
                          icon,
                          color: color ?? textColor,
                          size: iconSize,
                        ),
              isSuffixIcon
                  ? Container()
                  : icon == null
                      ? Container()
                      : const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                    color: color ?? textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight),
              ),
              !isSuffixIcon
                  ? Container()
                  : icon == null
                      ? Container()
                      : const SizedBox(width: 5),
              !isSuffixIcon
                  ? Container()
                  : icon == null
                      ? Container()
                      : Icon(
                          icon,
                          color: color ?? textColor,
                          size: iconSize,
                        ),
            ],
    );
  }
}
