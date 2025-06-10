import 'dart:io';
import 'package:auti_warrior_app/views/DoctorViews/user_photo_name.dart';
import 'package:flutter/material.dart';
// تأكد من صحة المسار

class DoctorProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;
  final String role;
  final String profileImageUrl;
  final File? imageFile;
  final VoidCallback onPickImage;

  const DoctorProfileHeaderWidget({
    Key? key,
    required this.fullName,
    required this.email,
    required this.role,
    required this.profileImageUrl,
    this.imageFile,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              UserPhotoAndName(
                name: fullName.isEmpty ? 'Doctor' : fullName,
                role: role.toUpperCase(),
                imageUrl: profileImageUrl,
                imageFile: imageFile,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPickImage,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              email.isEmpty ? 'No email available' : email,
              style: TextStyle(
                color: email.isEmpty
                    ? Colors.red.shade300
                    : Colors.blueGrey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
