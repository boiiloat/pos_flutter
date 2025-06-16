import 'package:flutter/material.dart';

final Color appColor = HexColor.fromHex("#E71C23");
final Color textColor = HexColor.fromHex("#364254");
final Color textSecondColor = HexColor.fromHex("#8b98ac");
final Color primaryColor = HexColor.fromHex("#1f3ef9");
final Color secondaryColor = HexColor.fromHex("#f3f3f3");
final Color successColor = HexColor.fromHex("#28a745");
final Color dangerColor = HexColor.fromHex("#CA0B00");
final Color errorColor = HexColor.fromHex("#dc3545");
final Color warningColor = HexColor.fromHex("#ffc107");
final Color infoColor = HexColor.fromHex("#17a2b8");
final Color lightColor = HexColor.fromHex("#f5f5f5");
final Color profileBorderColor = HexColor.fromHex("#4e90fe");
final Color homeIconColor = HexColor.fromHex("#c68642");
final Color homeKPIColor = HexColor.fromHex("#f8fbff");
final Color arrowback = HexColor.fromHex("#FFFFFF");

extension EIterable<E> on Iterable<E> {
  Iterable<E> sortedBy(Comparable Function(E e) key) =>
      toList()..sort((a, b) => key(a).compareTo(key(b)));
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String? hexString) {
    if ((hexString ?? "") != "") {
      try {
        final buffer = StringBuffer();
        if (hexString?.length == 6 || hexString?.length == 7) {
          buffer.write('ff');
        }
        buffer.write(hexString?.replaceFirst('#', ''));
        return Color(int.parse(buffer.toString(), radix: 16));
      } on Exception catch (_) {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class Constants {
  static const String baseUrl = 'http://localhost:8000/api';
}
