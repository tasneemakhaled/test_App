import 'package:auti_warrior_app/widgets/Registeration%20Widgets/already_have_account.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/custom_button.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/custom_text_form_field.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/role_drop_down.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/sign_up_helper.dart';
import 'package:auti_warrior_app/widgets/Validation/app_regex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ✅ أضفنا الاستيراد
import 'package:auti_warrior_app/services/storage_service.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String? selectedRole;
  final TextEditingController doctorLicenseController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  // ✅ أنشأنا instance من StorageService
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 550,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your first name';
                      }
                      if (!AppRegex.isValidName(value)) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                    icon: Icons.edit,
                    hintText: 'Enter your first name',
                    labelText: 'First Name',
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your last name';
                      }
                      if (!AppRegex.isValidName(value)) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                    icon: Icons.edit,
                    hintText: 'Enter last name',
                    labelText: 'Last Name',
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 20),
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
                    icon: Icons.email,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                    },
                    icon: Icons.visibility,
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20),
                  RoleDropDown(
                    selectedRole: selectedRole,
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (selectedRole == 'DOCTOR')
                    Column(
                      children: [
                        CustomTextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your medical license';
                            }
                            return null;
                          },
                          icon: Icons.card_membership,
                          labelText: 'Doctor License',
                          hintText: 'Enter your medical license',
                          controller: doctorLicenseController,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  SizedBox(
                    width: 140,
                    height: 30,
                    child: CustomButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // ✅ نفذ عملية التسجيل
                          await handleSignUp(
                            context,
                            selectedRole,
                            doctorLicenseController,
                            firstNameController,
                            lastNameController,
                            emailController,
                            passwordController,
                          );

                          // ✅ خزّن الأسماء في التخزين المحلي
                          await _storageService
                              .saveFirstName(firstNameController.text.trim());
                          await _storageService
                              .saveLastName(lastNameController.text.trim());

                          print("✅ تم حفظ الاسم بنجاح");
                        }
                      },
                    ),
                  ),
                  AlreadyHaveAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
