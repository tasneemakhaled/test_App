import 'package:flutter/material.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/views/RegisterationViews/login_view.dart';
import '../../help/constants.dart';
import '../../widgets/Profile Widgets/CustomDrawer.dart';
import '../../widgets/Profile Widgets/UserPhotoAndName.dart';

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({Key? key}) : super(key: key);
 
  @override
  _DoctorHomeViewState createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {
  final StorageService _storageService = StorageService();
  String? _firstName = '';
  String? _lastName = '';
  String? _role = '';
 
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
 
  Future _loadUserData() async {
    final firstName = await _storageService.getFirstName();
    final lastName = await _storageService.getLastName();
    final role = await _storageService.getRole();
   
    setState(() {
      _firstName = firstName;
      _lastName = lastName;
      _role = role;
    });
   
    print("👨‍⚕️ DoctorHomeView loaded with role: $_role");
  }
 
  @override
  Widget build(BuildContext context) {
    // Combine first name and last name for the CustomDrawer
    final fullName = '$_firstName $_lastName';
    
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Center(
          child: Text(
            'الملف الشخصي',
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontFamily: KFontFamily,
              fontSize: 32,
            ),
          ),
        ),
        // تم إزالة زر تسجيل الخروج من هنا
      ),
      // تمرير اسم المستخدم الكامل إلى CustomDrawer
      drawer: CustomDrawer(
        userName: fullName,
        imageUrl: 'https://example.com/user_photo.png',
      ),
      body: Column(
        children: [
          Center(
            child: UserPhotoAndName(
              imageUrl: 'https://example.com/user_photo.png',
              name: fullName,
              role: 'طبيب',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width - 60,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade500,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معلومات الطبيب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '• الدرجة العلمية: دكتوراه',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Text(
                  '• التخصص: طب الأطفال والتوحد',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Text(
                  '• سنوات الخبرة: 10',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Text(
                  '• الشهادات: متخصص في التوحد',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}