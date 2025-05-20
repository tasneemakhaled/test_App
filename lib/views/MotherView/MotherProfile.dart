// import 'package:flutter/material.dart';
// import '../../help/constants.dart';
// import '../../widgets/Profile Widgets/CustomDrawer.dart';
// import '../../widgets/Profile Widgets/UserPhotoAndName.dart';

// class MotherProfileView extends StatelessWidget {
//   const MotherProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Center(
//           child: Text(
//             'Profile',
//             style: TextStyle(
//               color: Colors.blueGrey.shade500,
//               fontFamily: KFontFamily,
//               fontSize: 32,
//             ),
//           ),
//         ),
//       ),
//       drawer: const CustomDrawer(
//         userName: '',
//       ), // Use CustomDrawer here
//       body: Column(
//         children: [
//           const Center(
//             child: UserPhotoAndName(
//               imageUrl:
//                   'https://example.com/user_photo.png', // Replace with actual photo URL
//               name: 'Jane Doe', // Replace with actual user name
//               role: 'MOTHER', // Replace with 'Doctor' or 'Mother' as needed
//             ),
//           ),
//           const SizedBox(
//               height:
//                   20), // Add some space between the user info and the container
//           Container(
//             width: MediaQuery.of(context).size.width -
//                 60, // Set the width to screen width minus 60
//             padding: const EdgeInsets.all(16), // Padding inside the container
//             decoration: BoxDecoration(
//               color: Colors.blueGrey.shade500, // Background color
//               borderRadius: BorderRadius.circular(10), // Rounded corners
//             ),
//             child: const Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start, // Align text to the start
//               children: [
//                 Text(
//                   'Child Information',
//                   style: TextStyle(
//                     color: Colors.white, // Text color
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   '• Age: 5 Years',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 Text(
//                   '• Condition: Autism Spectrum Disorder',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 Text(
//                   '• Strengths: Great at visual tasks and pattern recognition',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 Text(
//                   '• Challenges: Difficulty with communication and social interactions',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 Text(
//                   '• Recommendations: Occupational therapy and social skills training',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 // Add more information as needed
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
