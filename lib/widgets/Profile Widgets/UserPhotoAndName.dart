import 'package:flutter/material.dart';

import '../../help/constants.dart';

class UserPhotoAndName extends StatelessWidget {
  final String imageUrl; // URL or asset path for the user's photo
  final String name;
  final String role;

  const UserPhotoAndName({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 70, // Increased size of the avatar
          backgroundImage:
              NetworkImage(imageUrl), // Use AssetImage for local images
          // If you want to use an asset image, uncomment the line below and comment the NetworkImage line
          // backgroundImage: AssetImage('assets/images/user_photo.png'),
        ),
        const SizedBox(height: 10), // Space between the image and the text
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade500, // Set the text color
            fontFamily: KFontFamily, // Set the font family
          ),
        ),
        const SizedBox(height: 5), // Space between the name and the role
        Text(
          role,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey.shade500, // Set the text color
            fontFamily: KFontFamily, // Set the font family
          ),
        ),
      ],
    );
  }
}
