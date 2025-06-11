import 'dart:developer';
import 'package:auti_warrior_app/services/getAllDoctorsService.dart';
import 'package:flutter/material.dart';

import '../../models/doctorModels/AllDoctorsModel.dart';
import '../../widgets/Profile Widgets/DoctorCard.dart'; // تأكدي أن هذا المسار صحيح
import 'doctor_details_page.dart';
import 'package:auti_warrior_app/views/chats/ChatsView.dart'; // <-- تأكدي من استيراد ChatsView ومن صحة المسار

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
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final loadedDoctors = await getalldoctorsservice.getAllDoctors();

      if (!mounted) return;
      setState(() {
        doctors = loadedDoctors;
        _isLoading = false;
      });
    } catch (error) {
      log("❌ Error loading doctors: $error");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load doctors. Please try again.";
      });
    }
  }

  // **** التعديل الرئيسي هنا في هذه الدالة ****
  void handleChat(AllDoctorsModel doctor) {
    log('Navigating to chat with Dr. ${doctor.firstName} ${doctor.lastName}, Email: ${doctor.email}');

    // التأكد من أن الإيميل موجود وغير فارغ قبل الانتقال
    if (doctor.email != null && doctor.email!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatsView(email: doctor.email!), // تمرير الإيميل إلى ChatsView
        ),
      );
    } else {
      // إذا لم يكن الإيميل متوفرًا، أظهري رسالة خطأ للمستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot start chat. Doctor\'s email is not available.'),
          backgroundColor: Colors.red,
        ),
      );
      log('Chat cannot be initiated: Doctor email is null or empty for Dr. ${doctor.firstName} ${doctor.lastName}');
    }
  }
  // **** نهاية التعديل الرئيسي ****

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
        backgroundColor: Colors.blueGrey.shade700,
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDoctors,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blueGrey.shade700))
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade300, size: 50),
                        SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.refresh),
                          label: Text('Try Again'),
                          onPressed: _loadDoctors,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : doctors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 60, color: Colors.grey.shade400),
                          SizedBox(height: 16),
                          Text(
                            'No doctors available at the moment.',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Please check back later.',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadDoctors,
                      color: Colors.blueGrey.shade700,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return DoctorCard(
                              name: "${doctor.firstName} ${doctor.lastName}",
                              specialty:
                                  doctor.specialization ?? 'Psychologist',
                              email: doctor.email, // تم تمريره بالفعل
                              imageUrl: "https://via.placeholder.com/150",
                              experienceYears: doctor.yearsOfExperience,
                              onTapCard: () => navigateToDoctorDetails(doctor),
                              onChatPressed: () => handleChat(
                                  doctor), // هنا يتم استدعاء دالة handleChat المعدلة
                            );
                          }),
                    ),
    );
  }
}
