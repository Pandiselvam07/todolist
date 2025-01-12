import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenWidth * 0.042,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.2, vertical: screenHeight * 0.022),
        backgroundColor: Color(0xffFF0000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenHeight * 0.0070),
        ),
      ),
    );
  }
}
