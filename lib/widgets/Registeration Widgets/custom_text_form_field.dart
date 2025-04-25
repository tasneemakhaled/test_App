import 'package:auti_warrior_app/help/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.validator,
      required this.labelText,
      this.obscureText = false,
      required this.icon,
      this.controller,
      this.onChanged,
      required this.hintText});
  final String hintText;
  final Function(String)? onChanged;
  final String labelText;
  final bool obscureText;
  final IconData icon;
  final TextEditingController? controller;
  final Function(String?) validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return validator(value);
      },
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: Icon(
          icon,
          color: KColor,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: KColor,
          fontSize: 16,
          fontFamily: 'ADLaM Display',
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: KColor,
          fontSize: 16,
          fontFamily: 'ADLaM Display',
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: KColor, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: KColor, width: 1),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: KColor, width: 1),
        ),
      ),
    );
  }
}
