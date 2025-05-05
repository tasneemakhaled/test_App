import 'dart:developer';

import 'package:auti_warrior_app/services/getAllDoctorsService.dart';
import 'package:flutter/material.dart';

import '../../models/doctorModels/AllDoctorsModel.dart';
import '../../widgets/Profile Widgets/DoctorCard.dart';

class AvailableDoctorsPage extends StatefulWidget {
  @override
  _AvailableDoctorsPageState createState() => _AvailableDoctorsPageState();
}

class _AvailableDoctorsPageState extends State<AvailableDoctorsPage> {
  List<AllDoctorsModel> doctors = [];

  Getalldoctorsservice getalldoctorsservice = Getalldoctorsservice();

  @override
  void initState() {
    super.initState();
    getalldoctorsservice.getAllDoctors().then((value) {
      setState(() {
        doctors = value;
      });
    }).catchError((error) {
      log("❌ Error loading doctors: $error");
      // يمكنك عرض رسالة على الواجهة مثلاً أو Snackbar
    });
  }

  void handleSubscription(int index) {
    log('Subscribed to Dr. ${doctors[index].firstName} ${doctors[index].lastName}, Specialty: ${doctors[index].specialization ?? "Unknown"}');
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
                  name: "${doctor.firstName} ${doctor.lastName}",
                  specialty: doctor.specialization ?? 'Phycologist',
                  image: "https://via.placeholder.com/150",
                  onSubscribe: () => handleSubscription(index),
                );
              }),
    );
  }
}
