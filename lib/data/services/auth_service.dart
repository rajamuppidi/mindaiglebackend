import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mindaigle/core/config/api_config.dart'; // Import the ApiConfig
import 'package:flutter/material.dart'; // Import for navigation

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<http.Response> login(
      String email, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.getBaseUrl()}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('AuthService: Login response status: ${response.statusCode}');
      print('AuthService: Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final uid = responseData['uid'];

        // Store the token and UID securely
        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'uid', value: uid);
      } else {
        throw Exception('Failed to log in: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      print('Login failed with exception: $e');
      rethrow; // Re-throw the error so it can be handled elsewhere
    }
  }

  Future<http.Response> signup(
      String email, String password, String username) async {
    print('AuthService: Starting signup process');
    print(
        'AuthService: Sending request to ${ApiConfig.getBaseUrl()}/auth/signup');

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.getBaseUrl()}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );

      print('AuthService: Signup response status: ${response.statusCode}');
      print('AuthService: Signup response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final uid = responseData['uid'];

        print('AuthService: Storing token and UID in secure storage');
        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'uid', value: uid);
        print('AuthService: Token and UID stored successfully');
      } else {
        print('AuthService: Signup failed with status ${response.statusCode}');
        print('AuthService: Error message: ${response.body}');
      }

      return response;
    } catch (e) {
      print('AuthService: Exception during signup: $e');
      rethrow;
    }
  }

  Future<http.Response> checkUsernameAvailability(String username) async {
    final url =
        Uri.parse('${ApiConfig.getBaseUrl()}/auth/check-username/$username');
    try {
      return await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error in checkUsernameAvailability: $e');
      rethrow;
    }
  }

  Future<http.Response> resetPassword(String email) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.getBaseUrl()}/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
      }),
    );
    return response;
  }

  Future<void> signOut() async {
    print('Calling backend logout API');
    final token = await getToken();
    print('Token: $token'); // Log the token for verification
    final response = await http.post(
      Uri.parse('${ApiConfig.getBaseUrl()}/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Logout API response status: ${response.statusCode}');
    print('Logout API response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to log out');
    }

    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'uid');
  }

  // Helper method to get the stored UID
  Future<String?> getUid() async {
    return await _secureStorage.read(key: 'uid');
  }

  // Helper method to get the stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
}
