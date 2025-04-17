import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LeaveModeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const LeaveModeChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? appThemeGradientSoft : null,
          color: isSelected ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? AppColors.colorPrimary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

const LinearGradient appThemeGradientSoft = LinearGradient(
  colors: [Color(0xFF003862), Color.fromARGB(255, 78, 135, 179)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
