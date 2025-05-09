import 'dart:developer';

import 'package:auti_warrior_app/views/DoctorViews/user_photo_name.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../help/constants.dart';
import '../../models/doctorModels/UpdateProfileModel.dart';

import '../../services/DoctorProfileService.dart';
import '../../services/storage_service.dart';
import '../../widgets/Profile Widgets/CustomDrawer.dart';
import 'upload_certificate_view.dart';
import 'upload_post_view.dart';
import 'upload_choice_view.dart';

class DoctorHomeScreen extends StatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final StorageService _storageService = StorageService();
  final DoctorService _doctorService = DoctorService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Basic user information
  String _firstName = ''; // Will be loaded from API
  String _lastName = ''; // Will be loaded from API
  String _email = ''; // Will be loaded from API
  String _role = 'doctor'; // Default value
  String _profileImageUrl =
      'https://xsgames.co/randomusers/assets/avatars/male/64.jpg'; // Default doctor image

  // Doctor specific information (will be loaded from API)
  String _phoneNumber = '';
  String _specialization = '';
  String _doctorLicense = '';
  String _dateOfBirth = '';
  String _address = '';
  String _academicDegree = '';
  int _yearsOfExperience = 0;
  String _certificates = '';

  File? _profileImageFile;
  bool _isLoading = true; // Start with loading state
  Doctor? _doctorData;
  bool _showUpdateForm = false; // Flag to control form visibility

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _certificatesController = TextEditingController();

  // Default certificates
  List<Map<String, dynamic>> certificates = [
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

  // Default posts
  List<Map<String, dynamic>> posts = [
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
    // تهيئة وحدات التحكم في النموذج
    _populateControllers();
    // تحميل بيانات المستخدم
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // STEP 1: Get doctorId from storage
      final doctorIdStr = await _storageService.getDoctorId();

      // Handle case where doctorId is null or not available
      if (doctorIdStr == null || doctorIdStr.isEmpty) {
        print("⚠️ Doctor ID not found in storage");

        // Load basic data from storage as a fallback
        await _loadFromLocalStorage();

        setState(() {
          _isLoading = false;
        });
        return;
      }

      final doctorId = int.tryParse(doctorIdStr) ?? 1;
      print("👨‍⚕️ Fetching profile for doctor ID: $doctorId");

      // STEP 2: Call API to get doctor profile
      final doctorData = await _doctorService.getDoctorProfile(doctorId);

      if (doctorData != null) {
        setState(() {
          _doctorData = doctorData;

          // Update profile information from API
          // _firstName = doctorData.firstName;
          // _lastName = doctorData.lastName;
          // _email = doctorData.email;

          // Set doctor specific data
          _phoneNumber = doctorData.phoneNumber!;
          _specialization = doctorData.specialization;
          _doctorLicense = doctorData.doctorLicense;
          _dateOfBirth = doctorData.dateOfBirth;
          _address = doctorData.address;
          _academicDegree = doctorData.academicDegree;
          _yearsOfExperience = doctorData.yearsOfExperience;
          _certificates = doctorData.certificates;

          // Save to local storage for future use
          _storageService.saveFirstName(_firstName);
          _storageService.saveLastName(_lastName);
          _storageService.saveEmail(_email);

          // Populate form controllers with the data
          _populateControllers();
        });

        log("👨‍⚕️ Doctor profile loaded successfully from API");
      } else {
        log("⚠️ Doctor profile not found or empty response");
        // Fallback to local storage if API fails
        await _loadFromLocalStorage();
      }

      setState(() {
        _isLoading = false;
      });

      _logLoadedData(); // Log all the data we've loaded
    } catch (e) {
      print("❌ Error loading user data: $e");

      // Fallback to local storage if API fails
      await _loadFromLocalStorage();

      setState(() {
        _isLoading = false;
      });

      // Show error message to user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load profile data. Please try again.')),
        );
      });
    }
  }

// Helper method to load data from local storage
  Future<bool> _loadFromLocalStorage() async {
    try {
      // استرجاع البيانات من التخزين المحلي مع معالجة القيم الفارغة
      final email = await _storageService.getEmail();
      final firstName = await _storageService.getFirstName();
      final lastName = await _storageService.getLastName();
      final role = await _storageService.getRole() ?? 'doctor';

      print(
          "📦 Storage data - Email: $email, First: $firstName, Last: $lastName, Role: $role");

      // تحديث متغيرات الحالة والتحكم فقط إذا كانت القيم غير فارغة
      setState(() {
        // تحديث بيانات الاسم فقط إذا كانت القيم موجودة وغير فارغة
        if (firstName != '' && firstName.isNotEmpty) {
          _firstName = firstName;
          _firstNameController.text = firstName;
        }

        if (lastName != '' && lastName.isNotEmpty) {
          _lastName = lastName;
          _lastNameController.text = lastName;
        }

        if (email != null && email.isNotEmpty) {
          _email = email;
          _emailController.text = email;
        }

        _role = role;
      });

      // طباعة بيانات التصحيح بعد التحديث
      log("📧 Email loaded from local storage: $_email");
      log("👤 First name loaded from local storage: $_firstName");
      log("👤 Last name loaded from local storage: $_lastName");

      // التحقق من وجود بيانات فعلية
      return _email.isNotEmpty || _firstName.isNotEmpty || _lastName.isNotEmpty;
    } catch (e) {
      log("❌ Error loading from local storage: $e");
      return false;
    }
  } // Helper to log all loaded data for debugging

  void _logLoadedData() {
    log("\n===== DOCTOR PROFILE DATA =====");
    log("👤 Name: '$_firstName' '$_lastName'");
    log("📧 Email: '$_email'");
    log("👨‍⚕️ Role: '$_role'");
    log("☎️ Phone: '$_phoneNumber'");
    log("🏥 Specialization: '$_specialization'");
    log("🔍 License: '$_doctorLicense'");
    log("============================\n");
  }

  // Toggle the update form visibility
  void _toggleUpdateForm() {
    setState(() {
      _showUpdateForm = !_showUpdateForm;

      // Scroll to form if it's visible
      if (_showUpdateForm) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Scroll to form logic here if needed
        });
      }
    });
  }

  // Populate form fields with current data
  void _populateControllers() {
    // Always update all controllers with current state values
    _firstNameController.text = _firstName;
    _lastNameController.text = _lastName;
    _emailController.text = _email;
    _phoneController.text = _phoneNumber;
    _specializationController.text = _specialization;
    _licenseController.text = _doctorLicense;
    _birthDateController.text = _dateOfBirth;
    _addressController.text = _address;
    _degreeController.text = _academicDegree;
    _yearsController.text = _yearsOfExperience.toString();
    _certificatesController.text = _certificates;
  }

  // Save changes
  // Save changes
  // اضف هذه الدالة المعدلة إلى الملف doctorhomepage.dart

  Future<void> _saveProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // تحديث متغيرات الحالة من وحدات التحكم
      _firstName = _firstNameController.text;
      _lastName = _lastNameController.text;
      _email = _emailController.text;
      _phoneNumber = _phoneController.text;
      _specialization = _specializationController.text;
      _doctorLicense = _licenseController.text;
      _dateOfBirth = _birthDateController.text;
      _address = _addressController.text;
      _academicDegree = _degreeController.text;
      _yearsOfExperience = int.tryParse(_yearsController.text) ?? 0;
      _certificates = _certificatesController.text;

      // الحصول على doctorId من التخزين أو الافتراضي إلى 0
      final doctorIdStr = await _storageService.getDoctorId();
      final doctorId = doctorIdStr != null ? int.tryParse(doctorIdStr) ?? 0 : 0;

      final updatedDoctor = Doctor(
        doctorId: doctorId,
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        phoneNumber: _phoneNumber,
        specialization: _specialization,
        doctorLicense: _doctorLicense,
        dateOfBirth: _dateOfBirth,
        address: _address,
        academicDegree: _academicDegree,
        yearsOfExperience: _yearsOfExperience,
        certificates: _certificates,
      );

      // طباعة البيانات التي سيتم إرسالها إلى واجهة برمجة التطبيقات للتصحيح
      print("\n===== SENDING PROFILE DATA TO API =====");
      print(
          "👤 Name: '${updatedDoctor.firstName}' '${updatedDoctor.lastName}'");
      print("📧 Email: '${updatedDoctor.email}'");
      print("☎️ Phone: '${updatedDoctor.phoneNumber}'");
      print("🏥 Specialization: '${updatedDoctor.specialization}'");
      print("=================================\n");

      // حفظ البيانات محليًا قبل استدعاء API
      // هذا يضمن أن البيانات ستكون متاحة حتى لو فشل الاتصال بالخادم
      await _storageService.saveFirstName(_firstName);
      await _storageService.saveLastName(_lastName);
      await _storageService.saveEmail(_email);

      // حفظ doctorId إذا لم يكن محفوظًا بالفعل
      if (doctorId > 0) {
        await _storageService.saveDoctorId(doctorId.toString());
      }

      // استدعاء واجهة برمجة التطبيقات لتحديث الملف الشخصي
      final success = await _doctorService.completeProfile(updatedDoctor);

      if (success) {
        // إخفاء النموذج بعد التحديث الناجح
        setState(() {
          _showUpdateForm = false;
        });

        // عرض رسالة نجاح مع المعلومات المحدثة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحديث الملف الشخصي بنجاح'),
            duration: Duration(seconds: 2),
          ),
        );

        // تأكد من أن بطاقة معلومات الطبيب مرئية بعد الحفظ
        setState(() {
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحديث الملف الشخصي')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Failed to update profile: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: فشل تحديث الملف الشخصي')),
      );
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("❌ Error selecting image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image')),
      );
    }
  }

  Future<void> _addNewPost() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UploadPostView()),
      );

      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          posts.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': result['text'] ?? 'New Post',
            'imageUrl': result['imageUrl'],
            'isLocal': result['imageUrl'] != null,
          });
        });
      }
    } catch (e) {
      print("❌ Error adding new post: $e");
    }
  }

  void _deletePost(String id) {
    setState(() {
      posts.removeWhere((post) => post['id'] == id);
    });
  }

  Future<void> _addNewCertificate() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UploadCertificateView()),
      );

      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          certificates.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'title': result['title'] ?? 'New Certificate',
            'imageUrl': result['imageUrl'],
            'isLocal': result['imageUrl'] != null,
          });
        });
      }
    } catch (e) {
      print("❌ Error adding new certificate: $e");
    }
  }

  void _deleteCertificate(String id) {
    setState(() {
      certificates.removeWhere((cert) => cert['id'] == id);
    });
  }

  Widget _buildImageWidget(String? imageUrl, bool isLocal) {
    if (imageUrl == null) {
      // If image doesn't exist, show a default image or empty space
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Icon(
            Icons.image,
            size: 50,
            color: Colors.grey[400],
          ),
        ),
      );
    }

    try {
      // Try to display the image based on its type
      if (isLocal) {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("❌ Error displaying local image: $error");
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, color: Colors.red),
            );
          },
        );
      } else {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("❌ Error displaying network image: $error");
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, color: Colors.red),
            );
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
      print("❌ Exception when trying to display image: $e");
      return Container(
        color: Colors.grey[200],
        child: Icon(Icons.error, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show debugging info for name and email
    print("\n===== PROFILE SCREEN BUILDING =====");
    print("👤 Using name: '$_firstName' '$_lastName'");
    print("📧 Using email: '$_email'");
    print("================================\n");

    final fullName = '$_firstName $_lastName'.trim();
    final isDoctor = _role.toLowerCase() == "doctor";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Center(
          child: Text(
            'Doctor Profile',
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontFamily: KFontFamily,
              fontSize: 32,
            ),
          ),
        ),
        actions: [
          // Add refresh button to manually reload data
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUserData,
            tooltip: 'Refresh profile data',
          ),
        ],
      ),
      drawer: CustomDrawer(
        userName: fullName.isEmpty ? 'Doctor' : fullName,
        imageUrl: _profileImageFile == null ? _profileImageUrl : null,
        imageFile: _profileImageFile,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // Refresh data from API
                await _loadUserData();
                return Future.delayed(Duration(milliseconds: 300));
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User photo and profile section
                      Center(
                        child: Stack(
                          children: [
                            UserPhotoAndName(
                              name: fullName.isEmpty ? 'Doctor' : fullName,
                              role: 'DOCTOR',
                              imageUrl: _profileImageUrl,
                              imageFile: _profileImageFile,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickProfileImage,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade500,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Display name with better visibility
                      // Center(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 12.0),
                      //     child: Text(
                      //       fullName.isEmpty ? 'Doctor' : fullName,
                      //       style: TextStyle(
                      //         color: Colors.blueGrey.shade800,
                      //         fontSize: 22,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Display email with better visibility
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _email.isEmpty ? 'No email available' : _email,
                            style: TextStyle(
                              color: _email.isEmpty
                                  ? Colors.red.shade300
                                  : Colors.blueGrey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Add Update Profile button
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton.icon(
                            onPressed: _toggleUpdateForm,
                            icon: Icon(
                              _showUpdateForm ? Icons.close : Icons.edit,
                              color: Colors.white,
                            ),
                            label: Text(
                              _showUpdateForm ? 'Hide Form' : 'Update Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade500,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Doctor Information Card - Always show if there's any data
                      if (_firstName.isNotEmpty ||
                          _lastName.isNotEmpty ||
                          _phoneNumber.isNotEmpty ||
                          _specialization.isNotEmpty ||
                          _doctorLicense.isNotEmpty ||
                          _email.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Doctor Information',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Divider(color: Colors.white70, thickness: 1),
                              SizedBox(height: 10),
                              Text('• Full Name: $_firstName $_lastName',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              if (_email.isNotEmpty)
                                Text('• Email: $_email',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              if (_academicDegree.isNotEmpty)
                                Text('• Academic Degree: $_academicDegree',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              if (_specialization.isNotEmpty)
                                Text('• Specialization: $_specialization',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              Text('• Years of Experience: $_yearsOfExperience',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              if (_phoneNumber.isNotEmpty)
                                Text('• Phone Number: $_phoneNumber',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              if (_doctorLicense.isNotEmpty)
                                Text('• License Number: $_doctorLicense',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              if (_address.isNotEmpty)
                                Text('• Address: $_address',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              if (_dateOfBirth.isNotEmpty)
                                Text('• Date of Birth: $_dateOfBirth',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              if (_certificates.isNotEmpty)
                                Text('• Certificates: $_certificates',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),

                      SizedBox(height: 20),

                      // Profile update form - only show when _showUpdateForm is true
                      if (_showUpdateForm) ...[
                        Text(
                          'Update Your Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Add name fields
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _specializationController,
                          decoration: InputDecoration(
                            labelText: 'Specialization',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _licenseController,
                          decoration: InputDecoration(
                            labelText: 'License Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _birthDateController,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            // Add date picker logic here
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _birthDateController.text =
                                    "${picked.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _degreeController,
                          decoration: InputDecoration(
                            labelText: 'Academic Degree',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _yearsController,
                          decoration: InputDecoration(
                            labelText: 'Years of Experience',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _certificatesController,
                          decoration: InputDecoration(
                            labelText: 'Certificates',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),

                        SizedBox(height: 20),

                        Center(
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade500,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                            ),
                            child: Text(
                              'Save Changes',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                      ],

                      // Certificates section - moved outside the _showUpdateForm condition
                      if (!_showUpdateForm) ...[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Certificates 🏅',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: _addNewCertificate,
                              icon: Icon(Icons.add_circle),
                              color: Colors.blueGrey.shade500,
                              tooltip: 'Add Certificate',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: certificates.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final cert = certificates[index];
                            final bool isLocalImage = cert['isLocal'] == true;

                            return Stack(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: cert['imageUrl'] == null
                                            ? Container(
                                                color: Colors.grey[200],
                                                child: Icon(Icons.image,
                                                    color: Colors.grey[400]),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(10),
                                                ),
                                                child: _buildImageWidget(
                                                    cert['imageUrl'],
                                                    isLocalImage),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          cert['title'] ?? 'Certificate',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _deleteCertificate(cert['id']),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: 30),

                        // Posts section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Posts 📄',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: _addNewPost,
                              icon: Icon(Icons.add_circle),
                              color: Colors.blueGrey.shade500,
                              tooltip: 'Add Post',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        posts.isEmpty
                            ? Center(
                                child: Text(
                                  'No posts available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  final bool isLocalImage =
                                      post['isLocal'] == true;

                                  return Stack(
                                    children: [
                                      Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (post['imageUrl'] != null)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            10)),
                                                child: SizedBox(
                                                  height: 200,
                                                  width: double.infinity,
                                                  child: _buildImageWidget(
                                                      post['imageUrl'],
                                                      isLocalImage),
                                                ),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Text(
                                                post['text'] ?? '',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _deletePost(post['id']),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ],
                    ]),
              ),
            ),
      floatingActionButton: isDoctor
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UploadChoiceView()),
                );
              },
              child: const Icon(Icons.upload),
              backgroundColor: Colors.blueGrey,
            )
          : null,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _specializationController.dispose();
    _licenseController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _degreeController.dispose();
    _yearsController.dispose();
    _certificatesController.dispose();
    super.dispose();
  }
}
