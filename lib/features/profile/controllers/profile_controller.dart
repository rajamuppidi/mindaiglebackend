import 'package:flutter/material.dart';
import 'package:mindaigle/data/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:mindaigle/core/config/api_config.dart';

class ProfileController with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _username;
  String? _fullName;
  String? _location;
  String? _photoURL;
  String? _phoneNumber;
  int? _age;
  String? _gender;

  String? get username => _username;
  String? get fullName => _fullName;
  String? get location => _location;
  String? get photoURL => _photoURL;
  String? get phoneNumber => _phoneNumber;
  int? get age => _age;
  String? get gender => _gender;

  Future<void> fetchUserData() async {
    print('ProfileController: Starting to fetch user data');
    try {
      final uid = await _secureStorage.read(key: 'uid');
      print('ProfileController: UID from secure storage: $uid');
      if (uid == null) {
        throw Exception('User ID not found in secure storage');
      }

      final url = Uri.parse('${ApiConfig.getBaseUrl()}/profile/$uid');
      print('ProfileController: Fetching data from URL: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('ProfileController: Response status code: ${response.statusCode}');
      print('ProfileController: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _username = data['username'];
        _fullName = data['display_name'];
        _location = data['location'];
        _photoURL = data['photo_url'];
        _phoneNumber = data['phone_number'];
        _age = data['age'];
        _gender = data['gender'];
        print('ProfileController: User data successfully parsed');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to load user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('ProfileController: Error fetching user data: $e');
      print('ProfileController: Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    print('ProfileController: Attempting to sign out');
    try {
      await _authService.signOut();
      await _secureStorage.deleteAll();
      print('ProfileController: Sign out successful, secure storage cleared');
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (error) {
      print('ProfileController: Error during sign out: $error');
      // Optionally show an error message to the user
    }
  }

  Future<String> uploadProfilePicture(File image) async {
    print('ProfileController: Starting profile picture upload');
    try {
      final uid = await _secureStorage.read(key: 'uid');
      print('ProfileController: UID for profile picture upload: $uid');
      if (uid == null) {
        throw Exception('User ID not found for profile picture upload');
      }

      final url = Uri.parse(
          '${ApiConfig.getBaseUrl()}/profile/$uid/upload-profile-picture');
      print('ProfileController: Uploading to URL: $url');

      final request = http.MultipartRequest('POST', url);
      request.files
          .add(await http.MultipartFile.fromPath('profilePicture', image.path));

      final response = await request.send();
      print(
          'ProfileController: Upload response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        print(
            'ProfileController: Upload successful, new photo URL: ${data['photoURL']}');
        return data['photoURL'];
      } else {
        throw Exception(
            'Failed to upload profile picture. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('ProfileController: Error uploading profile picture: $e');
      print('ProfileController: Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<void> updateProfileDetails(Map<String, dynamic> profileData) async {
    print('ProfileController: Starting profile update');
    try {
      final uid = await _secureStorage.read(key: 'uid');
      if (uid == null) {
        throw Exception('User ID not found for profile update');
      }

      // Retrieve the current user's username to compare against new username
      final currentUserUsername = _username;

      if (profileData['username'] != null &&
          profileData['username'] != currentUserUsername) {
        // Perform availability check only if the username has changed
        final isAvailable =
            await checkUsernameAvailability(profileData['username']);
        if (!isAvailable) {
          print('ProfileController: Username is not available');
          throw Exception('Username is not available');
        }
      }

      final url = Uri.parse('${ApiConfig.getBaseUrl()}/profile/$uid');
      print('ProfileController: Updating profile at URL: $url');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        print('ProfileController: Profile successfully updated');
        _username = profileData['username'] ?? _username;
        _fullName = profileData['fullName'] ?? _fullName;
        _location = profileData['location'] ?? _location;
        _phoneNumber = profileData['phoneNumber'] ?? _phoneNumber;
        _age = profileData['age'] ?? _age;
        _gender = profileData['gender'] ?? _gender;
        notifyListeners();
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Unknown error occurred';
        print(
            'ProfileController: Failed to update profile details: $errorMessage');
        throw Exception('Failed to update profile details: $errorMessage');
      }
    } catch (e) {
      print('ProfileController: Error updating profile details: $e');
      rethrow;
    }
  }

  Future<bool> checkUsernameAvailability(String username) async {
    print('ProfileController: Checking username availability: $username');
    try {
      final currentUid = await _secureStorage.read(key: 'uid');
      final currentUsername = _username;
      print('ProfileController: Current UID: $currentUid');
      print('ProfileController: Current Username: $currentUsername');

      // If the username is the same as the current user's username, consider it available
      if (username == currentUsername) {
        print(
            'ProfileController: Username is the same as current user\'s username, considering it available');
        return true;
      }

      // Include UID as a query parameter
      final url = Uri.parse(
          '${ApiConfig.getBaseUrl()}/profile/check-username/$username?uid=$currentUid');
      print('ProfileController: Checking username at URL: $url');

      final response = await http.get(url);

      print(
          'ProfileController: Username check response status: ${response.statusCode}');
      print(
          'ProfileController: Username check response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Simplify the return by directly accessing the availability status
        return data['available'];
      } else {
        throw Exception(
            'Failed to check username availability. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('ProfileController: Error checking username availability: $e');
      rethrow;
    }
  }

  void navigateTo(BuildContext context, String routeName) {
    print('ProfileController: Navigating to $routeName');
    Navigator.of(context).pushNamed(routeName);
  }
}
