import 'package:auti_warrior_app/services/AuthService.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/models/AuthModels/LoginModel.dart';
import 'package:auti_warrior_app/views/DoctorViews/doctorhomepage.dart';

import 'package:auti_warrior_app/widgets/Validation/app_regex.dart';
import 'package:flutter/material.dart';
import 'package:auti_warrior_app/views/home_views/home_view.dart';

import 'custom_button.dart';
import 'custom_text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? email, password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();

  void _handleSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final loginModel = LoginModel(
          email: email!.trim(),
          password: password!.trim(),
        );

        final response = await _authService.login(loginModel);

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
            const SnackBar(
                content: Text("فشل تسجيل الدخول: لم يتم استلام رمز الدخول")),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تسجيل الدخول: $error")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _navigateBasedOnRole(String role) {
    print("🧭 توجيه المستخدم من LoginForm بناءً على الدور: $role");

    if (role.toUpperCase() == 'MOTHER') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (route) => false,
      );
    } else if (role.toUpperCase() == 'DOCTOR') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DoctorHomeView()),
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
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextFormField(
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الرجاء إدخال البريد الإلكتروني';
              }
              if (!AppRegex.isValidEmail(value)) {
                return 'الرجاء إدخال بريد إلكتروني صالح';
              }
              return null;
            },
            onChanged: (value) {
              email = value;
            },
            hintText: 'أدخل بريدك الإلكتروني',
            labelText: 'البريد الإلكتروني',
            icon: Icons.email,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الرجاء إدخال كلمة المرور';
              }
              // if (!AppRegex.isValidPassword(value)) {
              //   return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل،\nوتحتوي على أحرف كبيرة وصغيرة ورقم\nوحرف خاص';
              // }
              // return null;
            },
            onChanged: (value) {
              password = value;
            },
            hintText: 'أدخل كلمة المرور',
            labelText: 'كلمة المرور',
            icon: Icons.visibility,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 47,
            width: 214,
            child: isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: _handleSubmit,
                  ),
          ),
        ],
      ),
    );
  }
}
