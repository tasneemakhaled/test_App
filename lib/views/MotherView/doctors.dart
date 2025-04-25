import 'package:flutter/material.dart';

import '../../widgets/Profile Widgets/DoctorCard.dart';

class AvailableDoctorsPage extends StatefulWidget {
  @override
  _AvailableDoctorsPageState createState() => _AvailableDoctorsPageState();
}

class _AvailableDoctorsPageState extends State<AvailableDoctorsPage> {
  List<Map<String, String>> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    // Simulating fetching data from backend
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      doctors = [
        {
          'name': 'Dr. Ahmed Ali',
          'specialty': 'Pediatrician',
          'image': 'https://via.placeholder.com/150',
        },
        {
          'name': 'Dr. Sara Khalid',
          'specialty': 'Neurologist',
          'image': 'https://via.placeholder.com/150',
        },
        {
          'name': 'Dr. Omar Hassan',
          'specialty': 'Psychologist',
          'image': 'https://via.placeholder.com/150',
        },
      ];
    });
  }

  void handleSubscription(int index) {
    // Handle subscription logic (to be implemented)
    print('Subscribed to ${doctors[index]['name']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Doctors'),
        centerTitle: true,
      ),
      body: doctors.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return DoctorCard(
            name: doctor['name']!,
            specialty: doctor['specialty']!,
            image: doctor['image']!,
            onSubscribe: () => handleSubscription(index),
          );
        },
      ),
    );
  }
}