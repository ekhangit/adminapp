import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckInButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final bool isClockedIn;

  const CheckInButton({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.isClockedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final Gradient gradient =
        isClockedIn
            ? const LinearGradient(
              colors: [
                Color(0xFFFF8A65),
                Color(0xFFD84315),
              ], // Orange → Deep Orange
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
            : const LinearGradient(
              colors: [
                Color(0xFF4FC3F7),
                Color(0xFF1976D2),
              ], // Light Blue → Dark Blue
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );

    final shadowColor =
        isClockedIn
            ? Colors.deepOrangeAccent.withOpacity(0.4)
            : Colors.blueAccent.withOpacity(0.4);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 130,
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
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
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
