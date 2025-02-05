import 'package:flutter/material.dart';

class BuildElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double borderRadius;
  final double paddingVertical;
  final double paddingHorizontal;
  final IconData? icon;
  final Color? iconColor;
  final bool hasShadow;

  const BuildElevatedButton({
    required this.onPressed,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
    this.borderRadius = 12.0,
    this.paddingVertical = 18.0,
    this.paddingHorizontal = 40.0,
    this.icon,
    this.iconColor,
    this.hasShadow = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: hasShadow ? 4 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? textColor, size: 20),
            SizedBox(width: 8),
          ],
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}