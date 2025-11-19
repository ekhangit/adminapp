import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.85),
          boxShadow: kElevationToShadow[1],
          border: Border.all(color: AppColors.matteBlackColor, width: 0.05),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            color: AppColors.colorPrimary,
          ),
        ),
      ),
    );
  }
}
