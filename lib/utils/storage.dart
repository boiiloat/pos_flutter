import 'package:get_storage/get_storage.dart';

class Storage {
  static final GetStorage _box = GetStorage();

  static Future<void> saveToken(String token) async {
    await _box.write('token', token);
    print('Token saved: $token'); // Debug print
  }

  static String? getToken() {
    final token = _box.read('token');
    print('Retrieved token: $token'); // Debug print
    return token;
  }

  static Future<void> clear() async {
    await _box.erase();
    print('Storage cleared'); // Debug print
  }
}