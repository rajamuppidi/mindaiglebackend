import 'package:flutter/material.dart';
import 'package:mindaigle/features/profile/controllers/profile_controller.dart';
import 'package:mindaigle/features/resources/views/resources_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mindaigle/features/connections/views/connections_page.dart';
import 'package:mindaigle/features/wearable_device/views/werable_device_page.dart';

class ProfilePage extends StatefulWidget {
  final bool showAppBar;

  const ProfilePage({super.key, this.showAppBar = true});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();
  String username = '[username]';
  String fullName = '';
  String location = '';
  String profilePictureUrl = '';
  String phoneNumber = '';
  bool isUsernameAvailable = true;
  File? _image;
  late Future<void> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      await _controller.fetchUserData();
      setState(() {
        username = _controller.username ?? '[username]';
        fullName = _controller.fullName ?? '';
        location = _controller.location ?? '';
        profilePictureUrl = _controller.photoURL ?? '';
        phoneNumber = _controller.phoneNumber ?? '';
      });
      print('Fetched user data:');
      print('Username: $username');
      print('Full Name: $fullName');
      print('Location: $location');
      print('Profile Picture URL: $profilePictureUrl');
      print('Phone Number: $phoneNumber');
    } catch (e) {
      print('Error fetching user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load user data. Please try again.')),
      );
    }
  }

  Future<void> refreshProfileData() async {
    await _fetchUserData();
    setState(() {});
  }

  Future<void> _checkUsernameAvailability(String username) async {
    try {
      final isAvailable = await _controller.checkUsernameAvailability(username);
      setState(() {
        isUsernameAvailable = isAvailable;
      });
    } catch (e) {
      print('Error checking username availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error checking username availability.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_image != null) {
      try {
        final photoUrl = await _controller.uploadProfilePicture(_image!);
        setState(() {
          profilePictureUrl = photoUrl;
        });
      } catch (e) {
        print('Error uploading profile picture: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload profile picture.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<void>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error fetching user data'),
            ),
          );
        } else {
          return Scaffold(
            appBar: widget.showAppBar
                ? AppBar(
                    title: const Text('Profile'),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: const [],
                  )
                : null,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(theme),
                  _buildProfileOption(context, 'Daily Checkin',
                      Icons.fact_check, 'SocialEmotionalCheckin'),
                  _buildProfileOption(context, 'Weekly Self Report',
                      Icons.document_scanner, ''),
                  _buildProfileOption(context, 'Wearable Device',
                      Icons.watch_sharp, 'WearableDevice'),
                  _buildProfileOption(context, 'Wellness Score',
                      Icons.sports_score_sharp, 'WellnessScore'),
                  _buildProfileOption(context, 'Core Values',
                      Icons.privacy_tip_rounded, 'CoreValues'),
                  _buildProfileOption(
                      context, 'Connections', Icons.people, 'Connections'),
                  _buildProfileOption(
                      context, 'Resources', Icons.ios_share, 'Resources'),
                  _buildProfileOption(context, 'Social Determinants of Health',
                      Icons.ios_share, ''),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProfilePicture(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      phoneNumber,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                    Text(
                      location,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildEditProfileButton(theme),
          const SizedBox(width: 10),
          _buildSignOutButton(theme),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: CircleAvatar(
            backgroundImage: _image != null
                ? FileImage(_image!)
                : profilePictureUrl.isNotEmpty
                    ? NetworkImage(profilePictureUrl)
                    : const AssetImage(
                            'assets/images/default_profile_picture.png')
                        as ImageProvider,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: _buildEditPictureButton(),
        ),
      ],
    );
  }

  Widget _buildEditPictureButton() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.edit, size: 20, color: Colors.black),
      ),
    );
  }

  Widget _buildEditProfileButton(ThemeData theme) {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.white),
      onPressed: () => _showEditProfileModal(),
    );
  }

  Widget _buildSignOutButton(ThemeData theme) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app, color: Colors.white),
      onPressed: () => _controller.signOut(context),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, IconData icon, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            if (routeName.isNotEmpty) {
              if (routeName == 'Resources') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResourcesPage()),
                );
              } else if (routeName == 'Connections') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConnectionsPage()),
                );
              } else if (routeName == 'WearableDevice') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WearableDevicePage()),
                );
              } else {}
            }
          },
        ),
      ),
    );
  }

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProfileDetailsWidget(
          controller: _controller,
          location: location,
          onProfileUpdated: refreshProfileData,
        ),
      ),
    );
  }
}

class ProfileDetailsWidget extends StatefulWidget {
  final ProfileController controller;
  final String location;
  final VoidCallback onProfileUpdated;

  const ProfileDetailsWidget({
    super.key,
    required this.controller,
    required this.location,
    required this.onProfileUpdated,
  });

  @override
  _ProfileDetailsWidgetState createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends State<ProfileDetailsWidget> {
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
      print('Fetched user data in ProfileDetailsWidget:');
      print('Username: ${_usernameController.text}');
      print('Full Name: ${_fullNameController.text}');
      print('Location: ${_locationController.text}');
      print('Phone Number: ${_phoneNumberController.text}');
      print('Age: ${_ageController.text}');
      print('Gender: $_gender');
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
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
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const Icon(Icons.error, color: Colors.red)
                          : null,
                ),
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    if (value != _initialUsername) {
                      setState(() {
                        _isCheckingUsername = true;
                      });
                      final isAvailable = await widget.controller
                          .checkUsernameAvailability(value);
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
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (!_isUsernameAvailable && value != _initialUsername) {
                    return 'This username is not available';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
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
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Save Changes'),
                onPressed: () async {
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
                        const SnackBar(
                            content: Text('Profile updated successfully')),
                      );
                      widget.onProfileUpdated(); // Call the refresh method
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error updating profile: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Failed to update profile. Please try again.')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
