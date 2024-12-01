import 'package:flutter/material.dart';
import 'package:mindaigle/features/profile/controllers/profile_controller.dart';

class ProfileDetailsForm extends StatefulWidget {
  final ProfileController controller;
  final String location;
  final VoidCallback onProfileUpdated;

  const ProfileDetailsForm({
    super.key,
    required this.controller,
    required this.location,
    required this.onProfileUpdated,
  });

  @override
  _ProfileDetailsFormState createState() => _ProfileDetailsFormState();
}

class _ProfileDetailsFormState extends State<ProfileDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _gender;
  bool _isUsernameAvailable = true;
  bool _isCheckingUsername = false;
  String? _initialUsername;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      await widget.controller.fetchUserData();
      setState(() {
        _initialUsername = widget.controller.username;
        _usernameController.text = _initialUsername ?? '';
        _fullNameController.text = widget.controller.fullName ?? '';
        _locationController.text = widget.location;
        _phoneNumberController.text = widget.controller.phoneNumber ?? '';
        _ageController.text = widget.controller.age?.toString() ?? '';
        _gender = widget.controller.gender;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              suffixIcon: _isCheckingUsername
                  ? const CircularProgressIndicator()
                  : _usernameController.text.isNotEmpty
                      ? _isUsernameAvailable ||
                              _usernameController.text == _initialUsername
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red)
                      : null,
            ),
            onChanged: _checkUsernameAvailability,
            validator: _validateUsername,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your full name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: ['Male', 'Female', 'Other']
                .map((label) =>
                    DropdownMenuItem(value: label, child: Text(label)))
                .toList(),
            onChanged: (value) => setState(() => _gender = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
            validator: _validateAge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveChanges,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkUsernameAvailability(String value) async {
    if (value.isNotEmpty && value != _initialUsername) {
      setState(() => _isCheckingUsername = true);
      final isAvailable =
          await widget.controller.checkUsernameAvailability(value);
      setState(() {
        _isUsernameAvailable = isAvailable;
        _isCheckingUsername = false;
      });
    } else {
      setState(() {
        _isUsernameAvailable = true;
        _isCheckingUsername = false;
      });
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (!_isUsernameAvailable && value != _initialUsername) {
      return 'This username is not available';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.controller.updateProfileDetails({
          'username': _usernameController.text,
          'fullName': _fullNameController.text,
          'location': _locationController.text,
          'gender': _gender,
          'phoneNumber': _phoneNumberController.text,
          'age': int.tryParse(_ageController.text),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        widget.onProfileUpdated();
        Navigator.pop(context);
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to update profile. Please try again.')),
        );
      }
    }
  }
}
