import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final VoidCallback? onTap; // Add onTap parameter
  final void Function(String?)? onSaved; // Add onSaved property

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onTap, // Initialize onTap
    this.onSaved, // Initialize onSaved
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      onTap: onTap,
      onSaved: onSaved,
      readOnly: onTap != null,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
        prefixIcon: icon != null ? Icon(icon, color: Color(0xffFF0000)) : null,
        filled: false,
        fillColor: Colors.blue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xffFF0000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Color(0xffFF0000), width: 2), // Focus color
        ),
      ),
    );
  }
}
