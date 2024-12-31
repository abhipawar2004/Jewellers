import 'package:gehnamall/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Sign-Up Function
  static Future<Map<String, dynamic>> signUp(
      String phoneNumber, String name) async {
    final url = Uri.parse(
        'https://api.gehnamall.com/auth/register?phoneNumber=$phoneNumber&name=$name');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber, 'name': name}),
      );
      print('Signup response: ${response.body}');
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'data': data};
      }
    } catch (e) {
      print('Signup error: $e');
      return {
        'success': false,
        'data': {'message': 'Network error occurred'}
      };
    }
  }

  /// Login Function
  static Future<Map<String, dynamic>> login(String phoneNumber) async {
    final url = Uri.parse(
        'https://api.gehnamall.com/auth/login?phoneNumber=$phoneNumber');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'data': {'message': 'User not registered'},
        };
      } else {
        return {'success': false, 'data': data};
      }
    } catch (e) {
      return {
        'success': false,
        'data': {'message': 'Network error occurred'},
      };
    }
  }

  /// OTP Verification Function

  static Future<Map<String, dynamic>> verifyOtp(
      String phoneNumber, String otp) async {
    final url = Uri.parse(
        'https://api.gehnamall.com/auth/otpVerify?phoneNumber=$phoneNumber&otp=$otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber, 'otp': otp}),
      );

      print('Response Body: ${response.body}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // Save login state
        prefs.setBool('isLoggedIn', true);

        // Save userId if it exists
        if (data.containsKey('userId') && data['userId'] != null) {
          prefs.setString('userId', data['userId'].toString());
        }

        return {'success': true, 'data': data};
      } else {
        print('Error: Non-200 status code received: ${response.statusCode}');
        return {'success': false, 'data': json.decode(response.body)};
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {
        'success': false,
        'data': {'message': 'Network error occurred: $e'}
      };
    }
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Defaults to false if not set
  }

  // Logout function
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear specific keys related to user session and profile
    await prefs.remove('isLoggedIn');
    await prefs.remove('phoneNumber');
    await prefs.remove('userId');
    await prefs.remove('email'); // Add any other keys you use
    await prefs.remove('gender');
    await prefs.remove('address');
    await prefs.remove('pinCode');
    await prefs.remove('birthDate');
    await prefs.remove('spouseDate');

    // Optional: Clear all stored data if you want
    // await prefs.clear();

    print("Logout successful. All relevant data cleared.");
  }

  /// Fetch User ID from SharedPreferences
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Returns null if userId is not found
  }

  /// Update User Details
  static Future<Map<String, dynamic>> updateUserDetails({
    required String userId,
    required String email,
    required String gender,
    required String address,
    required String pinCode,
    required DateTime birthDate,
    DateTime? spouseDate,
  }) async {
    final url = Uri.parse('https://api.gehnamall.com/auth/updateUser/$userId');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'gender': gender,
          'address': address,
          'pinCode': pinCode,
          'birthDate': birthDate.toIso8601String(),
          if (spouseDate != null) 'spouseDate': spouseDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {'success': false, 'data': json.decode(response.body)};
      }
    } catch (e) {
      return {
        'success': false,
        'data': {'message': 'Network error occurred'},
      };
    }
  }


    static Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final url = Uri.parse("https://api.gehnamall.com/auth/getUserDetail/$userId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to fetch user details'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

}
