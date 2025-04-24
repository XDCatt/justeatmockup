import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.height,
    this.width,
    this.buttonColor,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String label;
  final double? height;
  final double? width;
  final Color? buttonColor;
  final Color? textColor;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Colors.orange.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: Size(
          width ?? MediaQuery.of(context).size.width * 0.8,
          height ?? 50,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white,
        ),
      )
    );
  }
}