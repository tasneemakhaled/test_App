import 'package:flutter/material.dart';
import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/widgets/Registeration%20Widgets/sign_up_form.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
            alignment: Alignment.center,
            child: SignUpForm(),
          ),
        ],
      ),
    );
  }
}
