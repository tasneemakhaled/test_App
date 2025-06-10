import 'dart:io';
import 'package:flutter/material.dart';

Widget buildImageWidget(String? imageUrl, bool isLocal) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_not_supported, // أو Icons.image
          size: 50,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  try {
    if (isLocal) {
      final file = File(imageUrl);
      if (!file.existsSync()) {
        print("❌ Local image file not found: $imageUrl");
        return _buildErrorImagePlaceholder();
      }
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("❌ Error displaying local image: $error");
          return _buildErrorImagePlaceholder(icon: Icons.broken_image);
        },
      );
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("❌ Error displaying network image ($imageUrl): $error");
          return _buildErrorImagePlaceholder(icon: Icons.cloud_off);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
  } catch (e) {
    print("❌ Exception when trying to display image ($imageUrl): $e");
    return _buildErrorImagePlaceholder();
  }
}

Widget _buildErrorImagePlaceholder({IconData icon = Icons.error_outline}) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Icon(
        icon,
        size: 50,
        color: Colors.red[300],
      ),
    ),
  );
}
