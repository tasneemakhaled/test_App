import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/views/RegisterationViews/forget_password2.dart';

import 'package:auti_warrior_app/widgets/Validation/app_regex.dart';
import 'package:flutter/material.dart';

import '../../widgets/Registeration Widgets/custom_button.dart';
import '../../widgets/Registeration Widgets/custom_text_form_field.dart';

class ForgetPassword1 extends StatelessWidget {
  const ForgetPassword1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: Stack(children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              KBackgroundimage,
              fit: BoxFit.cover,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                      height: 450,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 25),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Text(
                                'Verify your identity',
                                style: TextStyle(
                                  fontFamily: KFontFamily,
                                  color: KColor,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Enter your Email to receive reset code',
                                style: TextStyle(
                                  fontFamily: KFontFamily,
                                  color: KColor,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                  validator: (value) {
                                    if (value == null ||
                                        value!.isEmpty ||
                                        AppRegex.isValidName(value)) {
                                      return 'please enter a valid email';
                                    }
                                  },
                                  hintText: 'Enter your email',
                                  labelText: 'Email',
                                  icon: Icons.email),
                              SizedBox(
                                height: 60,
                              ),
                              CustomButton(
                                  text: 'Continue',
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ForgetPassword2();
                                    }));
                                  })
                            ]),
                          )))))
        ]));
  }
}
