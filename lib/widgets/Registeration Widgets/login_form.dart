import 'package:auti_warrior_app/services/AuthService.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:auti_warrior_app/models/AuthModels/LoginModel.dart';
import 'package:auti_warrior_app/views/DoctorViews/doctor_dashboard.dart';
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

        print("🔄 Attempting login with email: ${email!.trim()}");
        final response = await _authService.login(loginModel);

        if (response.token.isNotEmpty) {
          // Save all available user information to storage
          await _storageService.saveToken(response.token);
          await _storageService.saveRole(response.role);

          // Save email explicitly
          await _storageService.saveEmail(email!.trim());
          print("✅ Saved email to storage: ${email!.trim()}");

          // Get existing names in case response doesn't have them
          final existingFirstName = await _storageService.getFirstName();
          final existingLastName = await _storageService.getLastName();

          final firstName = response.firstName?.isNotEmpty == true
              ? response.firstName!
              : existingFirstName ?? "";
          final lastName = response.lastName?.isNotEmpty == true
              ? response.lastName!
              : existingLastName ?? "";

          await _storageService.saveFirstName(firstName);
          print("✅ Saved firstName to storage: '$firstName'");

          await _storageService.saveLastName(lastName);
          print("✅ Saved lastName to storage: '$lastName'");

          // Save doctorId if available
          if (response.doctorId != null) {
            await _storageService.saveDoctorId(response.doctorId.toString());
            print("✅ Saved doctorId to storage: ${response.doctorId}");
          }

          // Double check that we can retrieve the values we just saved
          final storedFirstName = await _storageService.getFirstName();
          final storedLastName = await _storageService.getLastName();
          print("🔍 Verification - Stored firstName: '$storedFirstName'");
          print("🔍 Verification - Stored lastName: '$storedLastName'");

          print(
              "🔐 Login successful! Redirecting based on role: ${response.role}");

          // Redirect user based on role
          _navigateBasedOnRole(response.role);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed: No token received")),
          );
        }
      } catch (error) {
        print("❌ Login error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $error")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _navigateBasedOnRole(String role) {
    print("🧭 Navigating user from LoginForm based on role: $role");

    // Clean up the role by extracting just the role name if it's in a complex format
    String cleanRole = role;

    // Use simpler comparison - case insensitive contains check
    if (cleanRole.toUpperCase().contains('DOCTOR')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DoctorDashboard()),
        (route) => false,
      );
    } else if (cleanRole.toUpperCase().contains('MOTHER')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid role received: $role")),
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
                return 'Please enter your email';
              }
              if (!AppRegex.isValidEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (value) {
              email = value;
            },
            hintText: 'Enter your email',
            labelText: 'Email',
            icon: Icons.email,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
            },
            onChanged: (value) {
              password = value;
            },
            hintText: 'Enter your password',
            labelText: 'Password',
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
                    text: 'Login',
                    onPressed: _handleSubmit,
                  ),
          ),
        ],
      ),
    );
  }
}
