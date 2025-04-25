import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/views/RegisterationViews/login_view.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          const Text(
            'Already have an account ?',
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
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ),
              );
            },
            child: const Text(
              'Sign in',
              style: TextStyle(
                color: KColor,
                fontSize: 16,
                fontFamily: KFontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
