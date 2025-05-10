import 'dart:developer';
import 'package:auti_warrior_app/services/getAllDoctorsService.dart';
import 'package:flutter/material.dart';

import '../../models/doctorModels/AllDoctorsModel.dart';
import '../../widgets/Profile Widgets/DoctorCard.dart';
import 'doctor_details_page.dart'; // Import the doctor details page

class AvailableDoctorsPage extends StatefulWidget {
  @override
  _AvailableDoctorsPageState createState() => _AvailableDoctorsPageState();
}

class _AvailableDoctorsPageState extends State<AvailableDoctorsPage> {
  List<AllDoctorsModel> doctors = [];
  bool _isLoading = true;
  String? _errorMessage;

  Getalldoctorsservice getalldoctorsservice = Getalldoctorsservice();

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final loadedDoctors = await getalldoctorsservice.getAllDoctors();

      setState(() {
        doctors = loadedDoctors;
        _isLoading = false;
      });
    } catch (error) {
      log("❌ Error loading doctors: $error");
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load doctors. Please try again.";
      });
    }
  }

  void handleSubscription(int index) {
    log('Subscribed to Dr. ${doctors[index].firstName} ${doctors[index].lastName}, Specialty: ${doctors[index].specialization ?? "Unknown"}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Subscribed to Dr. ${doctors[index].firstName} ${doctors[index].lastName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void navigateToDoctorDetails(AllDoctorsModel doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorDetailsPage(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Doctors'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDoctors,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDoctors,
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : doctors.isEmpty
                  ? Center(
                      child: Text(
                        'No doctors available at the moment',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadDoctors,
                      child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return GestureDetector(
                              onTap: () => navigateToDoctorDetails(doctor),
                              child: DoctorCard(
                                name: "${doctor.firstName} ${doctor.lastName}",
                                specialty:
                                    doctor.specialization ?? 'Psychologist',
                                image: "https://via.placeholder.com/150",
                                onSubscribe: () => handleSubscription(index),
                              ),
                            );
                          }),
                    ),
    );
  }
}
