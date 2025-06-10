import 'dart:developer';

import 'package:auti_warrior_app/views/DoctorViews/update_profile_form.dart';

import 'package:auti_warrior_app/views/DoctorViews/upload_certificate_view.dart';
import 'package:auti_warrior_app/views/DoctorViews/upload_choice_view.dart';
import 'package:auti_warrior_app/views/DoctorViews/upload_post_view.dart';
import 'package:auti_warrior_app/widgets/DoctorWidgets/build_image_widget.dart';
import 'package:auti_warrior_app/widgets/DoctorWidgets/doctor_certificates_widget.dart';
import 'package:auti_warrior_app/widgets/DoctorWidgets/doctor_information_display_widget.dart';
import 'package:auti_warrior_app/widgets/DoctorWidgets/doctor_post_widget.dart';
import 'package:auti_warrior_app/widgets/DoctorWidgets/doctor_profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Added for _pickProfileImage
import 'dart:io';

import '../../help/constants.dart';
import '../../models/doctorModels/UpdateProfileModel.dart';
import '../../services/DoctorProfileService.dart';
import '../../services/storage_service.dart';
import '../../widgets/Profile Widgets/CustomDrawer.dart';

class DoctorHomeScreen extends StatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final StorageService _storageService = StorageService();
  final DoctorService _doctorService = DoctorService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Doctor? _doctorData;

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _role = 'doctor';
  String _profileImageUrl =
      'https://xsgames.co/randomusers/assets/avatars/male/64.jpg';
  File? _profileImageFile;
  bool _isLoading = true;

  // Default certificates (can also be fetched if part of Doctor model later)
  List<Map<String, dynamic>> certificatesList = [
    {
      'id': '1',
      'title': 'Specialization in Autism Spectrum Disorder',
      'imageUrl':
          'https://img.freepik.com/free-vector/flat-certificate-template_52683-61537.jpg?t=st=1746367091~exp=1746370691~hmac=9cc2a41465a28becd13caa4bd4cda8b9cad11dc3499470f87988687d8e1a1ff2&w=1380',
      'isLocal': false
    },
    {
      'id': '2',
      'title': 'PhD in Pediatrics',
      'imageUrl':
          'https://img.freepik.com/free-psd/graduation-template-design_23-2151965033.jpg?t=st=1746367043~exp=1746370643~hmac=5ede014c270a7edfccf8589b1778708c4bb55422ad789c7b62eddfc090fb0781&w=1380',
      'isLocal': false
    },
    {
      'id': '3',
      'title': 'International Accreditation Certificate',
      'imageUrl':
          'https://img.freepik.com/premium-photo/education-concept-globe-certificate_441362-1904.jpg?w=1380',
      'isLocal': false
    },
  ];

  // Default posts (can also be fetched if part of Doctor model later)
  List<Map<String, dynamic>> postsList = [
    {
      'id': '1',
      'text':
          'Today\'s tip: Communication with children with autism requires patience and understanding. Using images and visual symbols greatly helps in improving communication with them.',
      'imageUrl':
          'https://img.freepik.com/free-photo/childrens-showing-different-signs_23-2148445710.jpg?t=st=1746367233~exp=1746370833~hmac=aa97733fb8cfa68211f5838c17d1c8e0506432c3224dcbea6e18efd5116b6631&w=740',
      'isLocal': false
    },
    {
      'id': '2',
      'text':
          'Group therapy sessions start next week at our center. Please contact the secretary for booking and inquiries.',
      'imageUrl':
          'https://img.freepik.com/free-photo/female-psychologist-consulting-young-couple_23-2148761461.jpg',
      'isLocal': false
    },
    {
      'id': '3',
      'text':
          'Reminder: The training workshop for parents will be held next Saturday at 10:00 AM.',
      'imageUrl': null,
      'isLocal': false
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _updateDisplayDataFromDoctor(Doctor? doctor) {
    if (doctor == null) {
      _firstName = '';
      _lastName = '';
      _email = '';
      _doctorData = null;
      return;
    }
    _doctorData = doctor;
    _firstName = doctor.firstName ?? '';
    _lastName = doctor.lastName ?? '';
    _email = doctor.email ?? '';
    // _role = doctor.role ?? 'doctor'; // If role comes from API
    // If certificatesList and postsList are part of the Doctor model, update them here.
    // e.g., certificatesList = doctor.certificatesList ?? [];
    // postsList = doctor.postsList ?? [];
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final doctorIdStr = await _storageService.getDoctorId();
      if (doctorIdStr == null || doctorIdStr.isEmpty) {
        log("⚠️ Doctor ID not found in storage. Attempting to load basic info.");
        final email = await _storageService.getEmail() ?? '';
        final firstName = await _storageService.getFirstName() ?? '';
        final lastName = await _storageService.getLastName() ?? '';
        if (mounted) {
          setState(() {
            _email = email;
            _firstName = firstName;
            _lastName = lastName;
            if (firstName.isNotEmpty ||
                lastName.isNotEmpty ||
                email.isNotEmpty) {
              _doctorData = Doctor(
                doctorId: 0,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phoneNumber: '',
                specialization: '',
                doctorLicense: '',
                dateOfBirth: '',
                address: '',
                academicDegree: '',
                yearsOfExperience: 0,
                certificates: '',
              );
            }
          });
        }
        return;
      }

      final doctorId = int.tryParse(doctorIdStr);
      if (doctorId == null) {
        log("⚠️ Invalid Doctor ID format in storage.");
        return;
      }

      log("👨‍⚕️ Fetching profile for doctor ID: $doctorId");
      final fetchedDoctorData = await _doctorService.getDoctorProfile(doctorId);

      if (fetchedDoctorData != null) {
        if (mounted) {
          setState(() {
            _updateDisplayDataFromDoctor(fetchedDoctorData);
          });
        }
        await _storageService.saveFirstName(fetchedDoctorData.firstName ?? '');
        await _storageService.saveLastName(fetchedDoctorData.lastName ?? '');
        await _storageService.saveEmail(fetchedDoctorData.email ?? '');
        log("👨‍⚕️ Doctor profile loaded successfully from API.");
      } else {
        log("⚠️ Doctor profile not found from API. Attempting to load basic info.");
        final email = await _storageService.getEmail() ?? '';
        final firstName = await _storageService.getFirstName() ?? '';
        final lastName = await _storageService.getLastName() ?? '';
        if (mounted) {
          setState(() {
            _email = email;
            _firstName = firstName;
            _lastName = lastName;
          });
        }
      }
    } catch (e) {
      log("❌ Error loading user data (HomeScreen): $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to load profile. Displaying cached data or try again.')),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
      _logLoadedData();
    }
  }

  void _logLoadedData() {
    log("\n===== DOCTOR DATA (HomeScreen) =====");
    if (_doctorData != null) {
      log("👤 Name: '${_doctorData!.firstName}' '${_doctorData!.lastName}'");
      log("📧 Email: '${_doctorData!.email}'");
      log("☎️ Phone: '${_doctorData!.phoneNumber}'");
      log("🎓 Degree: '${_doctorData!.academicDegree}'");
      log("🏥 Specialization: '${_doctorData!.specialization}'");
      // Log other fields from _doctorData as needed
    } else {
      log("No full doctor data loaded. Basic info: Name: '$_firstName $_lastName', Email: '$_email'");
    }
    log("============================\n");
  }

  Future<void> _navigateToUpdateProfile() async {
    if (_doctorData == null) {
      // If _doctorData is null but we have basic info, create a temporary Doctor object
      // This allows opening the update screen even if the full profile failed to load
      // but basic registration info (name, email) exists.
      if (_firstName.isNotEmpty || _lastName.isNotEmpty || _email.isNotEmpty) {
        _doctorData = Doctor(
          doctorId: 0, // Or try to get ID from storage if available
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          phoneNumber: '', specialization: '', doctorLicense: '',
          dateOfBirth: '', address: '', academicDegree: '',
          yearsOfExperience: 0, certificates: '',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No doctor data available to edit. Please try refreshing.')), // English
        );
        return;
      }
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfileScreen(doctorData: _doctorData),
      ),
    );

    if (result != null && result is Doctor) {
      if (mounted) {
        setState(() {
          _updateDisplayDataFromDoctor(result);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Profile updated successfully on the home screen!'), // English
            backgroundColor: Colors.teal,
          ),
        );
        _logLoadedData();
      }
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (mounted) {
          setState(() {
            _profileImageFile = File(pickedFile.path);
            // Here you might want to upload the image to a server and get a URL
            // Then update _profileImageUrl or _doctorData.profileImageUrl
          });
        }
      }
    } catch (e) {
      print("❌ Error selecting image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image')),
        );
      }
    }
  }

  Future<void> _addNewPost() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UploadPostView()),
      );

      if (result != null && result is Map<String, dynamic>) {
        if (mounted) {
          setState(() {
            postsList.insert(0, {
              // Insert at the beginning to show newest first
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'text': result['text'] ?? 'New Post',
              'imageUrl':
                  result['imageUrl'], // This could be a local path or a URL
              'isLocal': result['imageUrl'] != null &&
                  (result['imageUrl'] as String)
                      .startsWith('/'), // Basic check for local path
            });
          });
        }
      }
    } catch (e) {
      print("❌ Error adding new post: $e");
    }
  }

  void _deletePost(String id) {
    if (mounted) {
      setState(() {
        postsList.removeWhere((post) => post['id'] == id);
      });
    }
  }

  Future<void> _addNewCertificate() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UploadCertificateView()),
      );

      if (result != null && result is Map<String, dynamic>) {
        if (mounted) {
          setState(() {
            certificatesList.insert(0, {
              // Insert at the beginning
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'title': result['title'] ?? 'New Certificate',
              'imageUrl': result['imageUrl'],
              'isLocal': result['imageUrl'] != null &&
                  (result['imageUrl'] as String).startsWith('/'),
            });
          });
        }
      }
    } catch (e) {
      print("❌ Error adding new certificate: $e");
    }
  }

  void _deleteCertificate(String id) {
    if (mounted) {
      setState(() {
        certificatesList.removeWhere((cert) => cert['id'] == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullName = '$_firstName $_lastName'.trim();
    // final isDoctor = _role.toLowerCase() == "doctor";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doctor Profile', // English
            style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontFamily: KFontFamily, // Make sure KFontFamily is defined
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.blueGrey.shade700),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _loadUserData,
              tooltip: 'Refresh profile data'),
        ],
      ),
      drawer: CustomDrawer(
        userName: fullName.isEmpty ? 'Doctor' : fullName,
        // email: _email, // Pass email to drawer if needed
        imageUrl: _profileImageFile == null ? _profileImageUrl : null,
        imageFile: _profileImageFile,
        // onLogout: _logout, // Example: if you have a logout function
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blueGrey.shade500))
          : RefreshIndicator(
              onRefresh: _loadUserData,
              color: Colors.blueGrey.shade500,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DoctorProfileHeaderWidget(
                      fullName: fullName,
                      email: _email,
                      role: _role,
                      profileImageUrl: _profileImageUrl,
                      imageFile: _profileImageFile,
                      onPickImage: _pickProfileImage,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      // icon: Icon(Icons.edit_note, color: Colors.white),
                      label: Text('Update Your Profile', // English
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      onPressed: _navigateToUpdateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade500,
                        padding: EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                      ),
                    ),
                    SizedBox(height: 24),
                    if (_doctorData != null)
                      DoctorInformationDisplayWidget(
                        firstName: _doctorData!.firstName ?? '',
                        lastName: _doctorData!.lastName ?? '',
                        email: _doctorData!.email ?? '',
                        academicDegree: _doctorData!.academicDegree,
                        specialization: _doctorData!.specialization,
                        yearsOfExperience: _doctorData!.yearsOfExperience,
                        phoneNumber: _doctorData!.phoneNumber ?? '',
                        doctorLicense: _doctorData!.doctorLicense,
                        address: _doctorData!.address,
                        dateOfBirth: _doctorData!.dateOfBirth,
                        certificatesSummary: _doctorData!.certificates,
                      )
                    else if (!_isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                  Icons
                                      .person_search_outlined, // More relevant icon
                                  size: 40,
                                  color: Colors.grey.shade400),
                              SizedBox(height: 8),
                              Text(
                                'No profile data to display.', // English
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              TextButton(
                                  onPressed: _loadUserData,
                                  child: Text("Try Refreshing")) // English
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                    DoctorCertificatesWidget(
                      certificatesList: certificatesList,
                      onAddNewCertificate: _addNewCertificate,
                      onDeleteCertificate: _deleteCertificate,
                      buildImageWidget:
                          buildImageWidget, // From your build_image_widget.dart
                    ),
                    SizedBox(height: 30),
                    DoctorPostsWidget(
                      // Assuming this is the correct name for your posts widget
                      postsList: postsList,
                      onAddNewPost: _addNewPost,
                      onDeletePost: _deletePost,
                      buildImageWidget:
                          buildImageWidget, // From your build_image_widget.dart
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => UploadChoiceView()));
        },
        child: const Icon(Icons.upload, color: Colors.white),
        backgroundColor: Colors.blueGrey.shade500,
        tooltip: "Upload Content",
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
