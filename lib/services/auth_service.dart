import 'package:get/get.dart';
import 'package:pos_system/services/api_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // Reactive user profile
  final Rx<Map<String, dynamic>?> _userProfile =
      Rx<Map<String, dynamic>?>(null);
  Map<String, dynamic>? get userProfile => _userProfile.value;

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _apiService.post('/login', {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = response.body;
        print('Raw API Response: $responseData');

        if (responseData['token'] == null) {
          throw 'Invalid response: Missing token';
        }

        // 1. Get the user object from response
        final userData = responseData['user'] as Map<String, dynamic>? ?? {};
        print('Extracted User Data: $userData');

        // 2. Map to your expected structure
        final mappedUser = {
          'full_name': userData['fullname'], // Note the API uses 'fullname'
          'profile_image': userData['profile_image'],
          'id': userData['id'],
        };
        print('Mapped User Data: $mappedUser');

        // 3. Update reactive profile
        _userProfile.value = mappedUser;

        return {
          'token': responseData['token'],
          'user': mappedUser,
        };
      } else {
        throw response.body['message'] ?? 'Login failed';
      }
    } catch (e) {
      print('Login error details: $e');
      throw 'Login failed: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    _userProfile.value = null;
    // Clear storage/state as needed
  }
}
