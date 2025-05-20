import 'dart:ui';
import 'package:flutter/cupertino.dart';

// Constants
const KColor = Color(0xff94A5B4);
const KBackgroundimage = 'assets/images/background.png';
const KFontFamily = 'ADLaM Display';
const String baseUrl = "http://192.168.1.7:8081";
// Global screen width variable
late double kScreenWidth;

// Function to initialize screen width
void initScreenWidth(BuildContext context) {
  kScreenWidth = MediaQuery.of(context).size.width;
}
