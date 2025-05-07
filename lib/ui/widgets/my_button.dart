import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double? iconSize;
  final TextStyle? textStyle;
  final Color? buttonColor;
  final double? elevation;

  const MyButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconSize,
    this.textStyle,
    this.buttonColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(

      margin: EdgeInsets.all(12),
      width: screenWidth * 0.4,
      height: screenHeight*0.3,
      decoration: BoxDecoration(
        color: buttonColor ?? Colors.black38,
        borderRadius: BorderRadius.circular(12),

      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? 40,
              color: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle ??
                  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}