import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckInButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;
  final bool disabled;
  final bool isClockedIn;

  const CheckInButton({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    required this.disabled,
    this.isClockedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = disabled
        ? const LinearGradient(
            colors: [
              Color(0xFFB0BEC5), // Grey 300
              Color(0xFF78909C), // Grey 500
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : isClockedIn
            ? const LinearGradient(
                colors: [
                  Color(0xFFFF8A65), // Orange
                  Color(0xFFD84315), // Deep Orange
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [
                  Color(0xFF4FC3F7), // Light Blue
                  Color(0xFF1976D2), // Dark Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              );

    final shadowColor = disabled
        ? Colors.grey.withOpacity(0.2)
        : isClockedIn
            ? Colors.deepOrangeAccent.withOpacity(0.4)
            : Colors.blueAccent.withOpacity(0.4);

    final iconAndTextColor = disabled ? Colors.grey[300]! : Colors.white;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 25,
              spreadRadius: 5,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 40,
              height: 40,
              color: iconAndTextColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: iconAndTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}