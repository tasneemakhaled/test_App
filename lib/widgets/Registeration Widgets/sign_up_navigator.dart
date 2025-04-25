import 'package:flutter/material.dart';
import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/views/RegisterationViews/sign_up_view.dart';

class SignupNavigator extends StatelessWidget {
  const SignupNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            color: KColor,
            fontSize: 16,
            fontFamily: KFontFamily,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpView()),
            );
          },
          child: const Text(
            'SignUp',
            style: TextStyle(
              color: KColor,
              fontSize: 16,
              fontFamily: KFontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
