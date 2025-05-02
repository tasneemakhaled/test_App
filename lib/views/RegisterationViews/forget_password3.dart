import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/views/home_views/home_view.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/custom_button.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/custom_text_form_field.dart';
import 'package:auti_warrior_app/widgets/Validation/app_regex.dart';
import 'package:flutter/material.dart';

class ForgetPassword3 extends StatelessWidget {
  const ForgetPassword3({super.key});

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
                                'Enter Your Email',
                                style: TextStyle(
                                  fontFamily: KFontFamily,
                                  color: KColor,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      //     AppRegex.isValidPassword(value)) {
                                      return 'please enter a valid password';
                                    // }
                                  },
                                  hintText: 'Enter your password',
                                  labelText: 'NEW PASSWORD',
                                  icon: Icons.visibility),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      //     AppRegex.isValidPassword(value)) {
                                      return 'please enter a valid password';
                                    // }
                                  },
                                  hintText: 'Confirm your password',
                                  labelText: 'CONFIRM PASSWORD',
                                  icon: Icons.visibility),
                              SizedBox(
                                height: 25,
                              ),
                              CustomButton(
                                  text: 'Finish',
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomeView();
                                    }));
                                  }),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Don\'t receive code ? Resend',
                                style: TextStyle(
                                  fontFamily: KFontFamily,
                                  color: KColor,
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                          )))))
        ]));
  }
}
