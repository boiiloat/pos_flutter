import 'package:get/get.dart';

import 'en.dart';
import 'kh.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'kh_KHM': kh,
      };
}
