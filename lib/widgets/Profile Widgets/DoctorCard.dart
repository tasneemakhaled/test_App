import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String image;
  final VoidCallback onSubscribe;
  final VoidCallback? onTap; // Added onTap parameter

  const DoctorCard({
    Key? key,
    required this.name,
    required this.specialty,
    required this.image,
    required this.onSubscribe,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap, // Make the whole card clickable
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blueGrey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Doctor image
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(image),
              ),
              SizedBox(width: 16),
              // Doctor info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      specialty,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Hint text to show the card is clickable
                    Text(
                      'Tap to view details',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              // Subscribe button
              ElevatedButton(
                onPressed: () {
                  // Use a future to prevent the card's onTap from being triggered
                  Future.microtask(() => onSubscribe());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Subscribe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
