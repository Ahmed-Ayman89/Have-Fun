import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? iconColor;
  final Color? textColor;
  const CustomMenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.buttonColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        label: Text(
          label,
          textAlign: TextAlign.center,
        ),
        icon: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
