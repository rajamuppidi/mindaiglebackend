import 'package:flutter/material.dart';
import 'dart:io';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String phoneNumber;
  final String location;
  final String profilePictureUrl;
  final File? image;
  final Function() onEditProfile;
  final Function() onSignOut;
  final Function() onPickImage;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.location,
    required this.profilePictureUrl,
    this.image,
    required this.onEditProfile,
    required this.onSignOut,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                Text(
                  fullName,
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
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
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: onEditProfile,
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: onSignOut,
          ),
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
            backgroundImage: image != null
                ? FileImage(image!)
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
          child: InkWell(
            onTap: onPickImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 20, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
