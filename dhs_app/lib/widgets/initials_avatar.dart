import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

/// A circular avatar that shows initials (e.g. "SU") when there is no photo.
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 40,
    this.borderRadius = 8,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color:
            backgroundColor ?? AppColors.colorPrimary.withValues(alpha: 0.2),
      ),
      child: Text(
        initials,
        style: GoogleFonts.roboto(
          color: textColor ?? AppColors.colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.45,
        ),
      ),
    );
  }
}
