import 'package:ellelife/core/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData iconData;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool enabled;

  const CustomTextInputField({
    super.key,
    required this.controller,
    required this.iconData,
    required this.validator,
    required this.labelText,
    required this.obscureText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, size: 20),
        border: borderStyle,
        focusedBorder: borderStyle,
        enabledBorder: borderStyle,
        disabledBorder: borderStyle,
        labelText: labelText,
        labelStyle: TextStyle(color: enabled ? mainWhite : Colors.grey),
        filled: true,
      ),
      obscureText: obscureText,
    );
  }
}
