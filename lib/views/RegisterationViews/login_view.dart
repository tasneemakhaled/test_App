import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/views/RegisterationViews/forget_password1.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:auti_warrior_app/models/AuthModels/LoginModel.dart';
import 'package:auti_warrior_app/services/AuthService.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/views/home_views/home_view.dart';
import 'package:auti_warrior_app/views/DoctorViews/doctorhomepage.dart';

import '../../widgets/Registeration Widgets/curve.dart';

import '../../widgets/Registeration Widgets/sign_up_navigator.dart';
import '../../widgets/Registeration Widgets/social_login_buttons.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // تحقق من وجود جلسة سابقة عند بدء الشاشة
    _checkExistingSession();
  }

  /// تحقق من وجود توكن وتوجيه المستخدم إذا كان موجودًا
  void _checkExistingSession() async {
    final token = await _storageService.getToken();
    final role = await _storageService.getRole();

    if (token != null && token.isNotEmpty && role != null && role.isNotEmpty) {
      // لا نريد التوجيه التلقائي عند إعادة فتح التطبيق بعد تسجيل الخروج
      // لذلك سنتحقق من الوقت المنقضي منذ آخر خروج
      final lastLogout = await _storageService.getLastLogoutTime();
      final now = DateTime.now();

      // إذا كان آخر تسجيل خروج قبل أقل من دقيقة، فلا نقوم بتسجيل الدخول التلقائي
      if (lastLogout != null) {
        final difference = now.difference(lastLogout);
        if (difference.inMinutes < 1) {
          return;
        }
      }

      _navigateBasedOnRole(role);
    }
  }

  /// تنفيذ عملية تسجيل الدخول
  void _handleLogin() async {
    setState(() => isLoading = true);

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("يرجى إدخال البريد الإلكتروني وكلمة المرور")),
      );
      setState(() => isLoading = false);
      return;
    }

    final loginModel = LoginModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      final response = await _authService.login(loginModel);

      print("🔍 Login Response - Token: ${response.token.substring(0, 20)}...");
      print("🔍 Login Response - Role: ${response.role}");

      // حفظ بيانات المستخدم عند النجاح
      if (response.token.isNotEmpty) {
        await _storageService.saveToken(response.token);
        await _storageService.saveRole(response.role);
        if (response.firstName != null) {
          await _storageService.saveFirstName(response.firstName!);
        }
        if (response.lastName != null) {
          await _storageService.saveLastName(response.lastName!);
        }

        // توجيه المستخدم بناءً على الدور
        _navigateBasedOnRole(response.role);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لم يتم استلام رمز الدخول")),
        );
      }
    } catch (error) {
      print("❌ خطأ في تسجيل الدخول: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل تسجيل الدخول: $error")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _navigateBasedOnRole(String role) {
    print("🧭 توجيه المستخدم بناءً على الدور: $role");

    // Use simpler comparison - case insensitive contains check
    if (role.toUpperCase().contains('DOCTOR')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DoctorHomeView()),
        (route) => false,
      );
    } else if (role.toUpperCase().contains('MOTHER')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم استلام دور غير صالح: $role")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              KBackgroundimage,
              fit: BoxFit.cover,
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 70.0),
              child: Text(
                'Autiwarrior',
                style: TextStyle(
                  fontFamily: KFontFamily,
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  ClipPath(
                    clipper: TopCurveClipper(),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          const LoginForm(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPassword1(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  color: KColor,
                                  fontSize: 16,
                                  fontFamily: KFontFamily,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Or Continue With',
                            style: TextStyle(
                              color: KColor,
                              fontSize: 16,
                              fontFamily: KFontFamily,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const SocialLoginButtons(),
                          const SizedBox(height: 5),
                          const SignupNavigator(),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
