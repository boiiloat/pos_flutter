import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/services/api_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  final Rx<Map<String, dynamic>?> _userProfile =
      Rx<Map<String, dynamic>?>(null);
  Map<String, dynamic>? get userProfile => _userProfile.value;

  // Add this getter to easily check user role
  bool get isAdmin => _userProfile.value?['role_id'] == 1;
  bool get canCreateUser => _userProfile.value?['role_id'] == 1;

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _apiService.post('/login', {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = response.body;

        if (responseData['token'] == null) {
          throw 'Invalid response: Missing token';
        }

        final userData = responseData['user'] as Map<String, dynamic>? ?? {};

        // Include role_id in the mapped user data
        final mappedUser = {
          'full_name': userData['fullname'],
          'profile_image': userData['profile_image'],
          'id': userData['id'],
          'role_id': userData['role_id'], // Add this line
          'username': userData['username'], // Add this line
        };

        _userProfile.value = mappedUser;

        return {
          'token': responseData['token'],
          'user': mappedUser,
        };
      } else {
        throw response.body['message'] ?? 'Login failed';
      }
    } catch (e) {
      Program.error('Login', " ${e.toString()}");
      throw 'Login failed: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    _userProfile.value = null;
  }
}
