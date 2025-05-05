import 'package:flutter/material.dart';
import 'dart:io';

class UserPhotoAndName extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final String name;
  final String role;

  const UserPhotoAndName({
    Key? key,
    this.imageUrl,
    this.imageFile,
    required this.name,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blueGrey.shade300,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  )
                : imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          );
                        },
                      )
                    : const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
