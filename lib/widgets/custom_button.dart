import 'package:flutter/material.dart';
import 'package:mylibrary/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? width;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.text,
    this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? Constants.screenWidth(context), 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.red,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
