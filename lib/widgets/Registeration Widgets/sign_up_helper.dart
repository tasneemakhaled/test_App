import 'package:flutter/material.dart';
import 'package:auti_warrior_app/views/home_views/home_view.dart';
import 'package:auti_warrior_app/views/DoctorViews/doctorhomepage.dart';
import 'package:auti_warrior_app/services/AuthService.dart';
import 'package:auti_warrior_app/models/AuthModels/RegisterModel.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/models/AuthModels/LoginModel.dart';

Future<void> handleSignUp(
    BuildContext context,
    String? selectedRole,
    TextEditingController doctorLicenseController,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController passwordController) async {
  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  if (selectedRole == null) {
    Navigator.pop(context); // Close loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الرجاء اختيار دور')),
    );
    return;
  }

  if (selectedRole == 'DOCTOR' && doctorLicenseController.text.isEmpty) {
    Navigator.pop(context); // Close loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الرجاء إدخال رخصة الطبيب')),
    );
    return;
  }

  try {
    // Create RegisterModel from form data
    final registerModel = RegisterModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: selectedRole,
      // Include doctorLicense only for doctors
      doctorLicense:
          selectedRole == 'DOCTOR' ? doctorLicenseController.text.trim() : null,
    );

    print("📝 Registering user with data: ${registerModel.toJson()}");

    // Call the AuthService to register the user
    final authService = AuthService();
    final response = await authService.register(registerModel);

    print(
        "🔹 Register Response: token=${response.token}, role=${response.role}");

    // إذا كان الرمز المميز مؤقتًا (temp_token)، قم بتسجيل الدخول للحصول على رمز حقيقي
    if (response.token == "temp_token") {
      print("🔹 Temp token received, attempting login to get real token");
      try {
        // محاولة تسجيل الدخول مباشرة بعد التسجيل للحصول على الرمز الحقيقي
        final loginModel = LoginModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final loginResponse = await authService.login(loginModel);

        // استخدام استجابة تسجيل الدخول بدلاً من استجابة التسجيل
        print(
            "🔹 Login Response: token=${loginResponse.token}, role=${loginResponse.role}");

        // حفظ بيانات المستخدم في التخزين المحلي
        final storageService = StorageService();
        await storageService.saveToken(loginResponse.token);
        await storageService.saveRole(loginResponse.role);
        if (loginResponse.firstName != null) {
          await storageService.saveFirstName(loginResponse.firstName!);
        }
        if (loginResponse.lastName != null) {
          await storageService.saveLastName(loginResponse.lastName!);
        }

        // إظهار رسالة نجاح
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // إغلاق مربع حوار التحميل
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التسجيل بنجاح!')),
        );

        // التنقل إلى العرض المناسب بناءً على الدور
        print("🚀 Navigating based on role: ${loginResponse.role}");

        if (loginResponse.role == 'DOCTOR') {
          print("🔷 Navigating to Doctor Home View");
          await Future.delayed(Duration(
              milliseconds: 500)); // تأخير صغير للتأكد من أن SnackBar مرئي
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DoctorHomeView()),
            (route) => false,
          );
        } else if (loginResponse.role == 'MOTHER') {
          print("🔷 Navigating to Mother Home View");
          await Future.delayed(Duration(
              milliseconds: 500)); // تأخير صغير للتأكد من أن SnackBar مرئي
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
            (route) => false,
          );
        } else {
          print("⚠️ Unknown role: ${loginResponse.role}");
          throw Exception("دور غير معروف: ${loginResponse.role}");
        }

        return;
      } catch (loginError) {
        print("❌ Login after registration failed: $loginError");
        // لا نرمي الخطأ هنا، بل نستمر باستخدام استجابة التسجيل الأصلية
      }
    }

    // Close loading dialog
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Save user data to local storage
    final storageService = StorageService();
    await storageService.saveToken(response.token);
    await storageService.saveRole(response.role);
    if (response.firstName != null) {
      await storageService.saveFirstName(response.firstName!);
    }
    if (response.lastName != null) {
      await storageService.saveLastName(response.lastName!);
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم التسجيل بنجاح!')),
    );

    // Navigate to appropriate view based on role
    print("🚀 Navigating based on role: ${response.role}");

    if (response.role == 'DOCTOR') {
      print("🔷 Navigating to Doctor Home View");
      await Future.delayed(Duration(
          milliseconds: 500)); // Small delay to ensure SnackBar is visible
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DoctorHomeView()),
        (route) => false,
      );
    } else if (response.role == 'MOTHER') {
      print("🔷 Navigating to Mother Home View");
      await Future.delayed(Duration(
          milliseconds: 500)); // Small delay to ensure SnackBar is visible
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (route) => false,
      );
    } else {
      print("⚠️ Unknown role: ${response.role}");
      throw Exception("دور غير معروف: ${response.role}");
    }
  } catch (error) {
    print("❌ Registration error: $error");
    // Close loading dialog
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل التسجيل: $error')),
    );
  }
}
