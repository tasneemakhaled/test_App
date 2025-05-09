import 'package:flutter/material.dart';
import '../../views/DoctorViews/doctorhomepage.dart';
import '../../views/payment/paymentmethod.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String image;
  final VoidCallback onSubscribe;

  // Define your custom font family (e.g., KFontFamily)
  static const String kFontFamily = 'KFontFamily';

  const DoctorCard({
    required this.name,
    required this.specialty,
    required this.image,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.blueGrey.shade500, // Set the background color
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: GestureDetector(
          onTap: () {
            // Navigate to DoctorHomeView when the image is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
            );
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(image),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: kFontFamily, // Set the font family
          ),
        ),
        subtitle: Text(specialty),
        trailing: ElevatedButton(
          onPressed: () {
            // Navigate to PaymentPage when "Book Now" is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentMethod()),
            );
          },
          child: Text('Book Now'),
        ),
      ),
    );
  }
}
