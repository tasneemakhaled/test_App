import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auti_warrior_app/help/constants.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({Key? key}) : super(key: key);

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        log("Google Sign-In Successful: \${googleUser.displayName}");
      }
    } catch (error) {
      log("Google Sign-In Error: \$error");
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.i.login();
      if (result.status == LoginStatus.success) {
        log("Facebook Sign-In Successful");
      }
    } catch (error) {
      log("Facebook Sign-In Error: \$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 155,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: signInWithFacebook,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(KColor),
            ),
            label: const Text(
              'Facebook',
              style: TextStyle(
                color: Colors.white,
                fontFamily: KFontFamily,
                fontSize: 16,
              ),
            ),
            icon: const Icon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 155,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: signInWithGoogle,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(KColor),
            ),
            label: const Text(
              'Google',
              style: TextStyle(
                color: Colors.white,
                fontFamily: KFontFamily,
                fontSize: 16,
              ),
            ),
            icon: const Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
