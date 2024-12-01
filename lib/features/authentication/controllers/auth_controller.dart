import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mindaigle/data/services/auth_service.dart';
import 'package:mindaigle/features/dashboard/views/dashboard_page.dart';
import 'package:http/http.dart' as http;

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final response = await _authService.login(email, password, context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        // Navigate to the ProfilePage if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> signup(BuildContext context, String email, String password,
      String username) async {
    try {
      print('AuthController: Starting signup process');
      final response = await _authService.signup(email, password, username);

      if (response.statusCode == 200) {
        print('AuthController: Signup successful');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('AuthController: Signup failed');
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Unknown error occurred';
        final errorDetails = errorData['details'] ?? '';
        print('AuthController: Error message: $errorMessage');
        print('AuthController: Error details: $errorDetails');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Signup failed: $errorMessage\n$errorDetails')),
        );
      }
    } catch (e) {
      print('AuthController: Exception during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during signup: $e')),
      );
    }
  }

  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await _authService.checkUsernameAvailability(username);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['available'] as bool;
      } else {
        print(
            'Username availability check failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      if (e is http.ClientException) {
        print('Network error: ${e.message}');
        print('URI: ${e.uri}');
      } else {
        print('An error occurred while checking username availability: $e');
      }
      return false;
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      final response = await _authService.resetPassword(email);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
        Navigator.pushNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to send password reset email. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  String getPasswordHelpText(String password) {
    final criteria = [
      RegExp(r'.{8,}').hasMatch(password),
      RegExp(r'[A-Z]').hasMatch(password),
      RegExp(r'\d').hasMatch(password),
      RegExp(r'[!@#\$&*~]').hasMatch(password),
    ];

    final messages = [
      'At least 8 characters',
      'At least 1 uppercase letter',
      'At least 1 number',
      'At least 1 special character',
    ];

    final helpText = <String>[];
    for (var i = 0; i < criteria.length; i++) {
      if (!criteria[i]) {
        helpText.add(messages[i]);
      }
    }

    return helpText.isEmpty
        ? 'Password is strong'
        : 'Password must include: ${helpText.join(', ')}';
  }

  bool validatePassword(BuildContext context, String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Password must be at least 8 characters long, include an uppercase letter, a number, and a special character.')),
      );
      return false;
    }
    return true;
  }
}
