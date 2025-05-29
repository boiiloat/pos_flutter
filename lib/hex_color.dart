import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    final cleanHex = hexColor.toUpperCase().replaceAll("#", "");
    if (cleanHex.length == 6) {
      return int.parse("FF$cleanHex", radix: 16);
    } else if (cleanHex.length == 8) {
      return int.parse(cleanHex, radix: 16);
    }
    throw FormatException("Invalid hex color format");
  }

  HexColor.fromHex(final String hexColor) : super(_getColorFromHex(hexColor));
}