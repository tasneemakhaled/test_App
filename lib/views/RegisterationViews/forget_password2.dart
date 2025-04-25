import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/views/RegisterationViews/forget_password3.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/custom_button.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgetPassword2 extends StatelessWidget {
  const ForgetPassword2({super.key});

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
                                height: 25,
                              ),
                              Text(
                                'We’ve sent an email to H*****@gmail.com',
                                style: TextStyle(
                                  fontFamily: KFontFamily,
                                  color: KColor,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value!.isEmpty) {
                                      return 'please enter a valid code';
                                    }
                                  },
                                  hintText: 'Enter code',
                                  labelText: 'ENTER CODE',
                                  icon: Icons.send),
                              SizedBox(
                                height: 60,
                              ),
                              CustomButton(
                                  text: 'Continue',
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ForgetPassword3();
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
