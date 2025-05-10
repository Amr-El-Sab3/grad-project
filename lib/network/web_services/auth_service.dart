// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = 'https://stiff-keslie-a7medbibars-f69765cc.koyeb.app';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['token'];
      SharedPreferences prefsToken = await SharedPreferences.getInstance();
      await prefsToken.setString('user_token', token); // Changed from 'token' to 'user_token'

      print('Token saved successfully: $token'); // Debug log
      return token;
    } else {
      throw Exception('Login failed');
    }
  }


  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    return prefsToken.containsKey('user_token'); // Changed from 'token' to 'user_token'
  }

  Future<void> logout() async {
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    
    final response = await http.post(Uri.parse('$_baseUrl/logout'));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to logout');
    }
    await prefsToken.remove('user_token');
  }

  Future<void> register(String firstName, String lastName, String email,
      String password, String cPassword, String phone, String dop) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': firstName,
        "lastName": lastName,
        'email': email,
        'password': password,
        "cPassword": cPassword,
        "phone": phone,
        "DOB": dop
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Registration failed');
    }
  }

  Future<void> verifyAccount(String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify/$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to verify account');
    }
  }


  Future<void> deleteUser() async {
    final response = await http.delete(Uri.parse('$_baseUrl/delete'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }


  Future<void> updatePassword(String oldPassword, String newPassword , String cPassword) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/update-password'),
      headers: {'Content-Type': 'application/json'},
      body:
      jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword ,"cPassword": cPassword }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update password');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(Uri.parse('$_baseUrl/user/profile'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  Future<void> forgetPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/forget-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send reset password email');
    }
  }

  Future<void> changePasswordWithOTP(String email ,String otp, String newPassword , String cPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/change-password-with-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email ,'otp': otp, 'newPassword': newPassword ,"cPassword":cPassword }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to change password with OTP');
    }
  }

  Future<void> googleLogin(String idToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to login with Google');
    }
  }

  Future<void> recoverPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/forget-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Password recovery failed');
    }
  }
}
