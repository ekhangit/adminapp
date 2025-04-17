import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/app_colors.dart';

class AttendanceInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath;

  const AttendanceInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.lightGreyTextColor,
            ),
          ),
          const SizedBox(height: 4),
          SvgPicture.asset(
            iconPath,
            height: 20,
            color: AppColors.lightGreyTextColor,
          ),
        ],
      ),
    );
  }
}
