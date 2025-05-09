import 'package:auti_warrior_app/views/DoctorViews/doctorhomepage.dart';
import 'package:flutter/material.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/views/home_views/home_view.dart';
import 'package:auti_warrior_app/views/RegisterationViews/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // للتأكد من تهيئة Flutter

  // الحصول على التوكن والدور
  final StorageService storageService = StorageService();
  String? token = await storageService.getToken();
  String? role = await storageService.getRole();

  // تحديد الصفحة الأولى بناءً على حالة تسجيل الدخول والدور
  Widget startScreen;
  if (token != null && token.isNotEmpty) {
    if (role == 'MOTHER') {
      startScreen = const HomeView();
    } else if (role == 'DOCTOR') {
      startScreen = DoctorHomeScreen();
    } else {
      startScreen = LoginView();
    }
  } else {
    startScreen = LoginView();
  }

  runApp(MyApp(startScreen: startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({Key? key, required this.startScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auti Warrior',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: startScreen,
      routes: {
        '/login': (context) => LoginView(),
        '/home': (context) => const HomeView(),
        '/doctorHome': (context) => DoctorHomeScreen(),
      },
    );
  }
}
