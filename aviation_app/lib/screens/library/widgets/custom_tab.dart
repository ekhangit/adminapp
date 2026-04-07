import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/library/library_controller.dart';
import '../../../utils/app_colors.dart';

class CustomTab extends StatelessWidget {
  final LibraryController controller;
  final String title;
  final int index;

  const CustomTab({
    super.key,
    required this.controller,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedDocumentTab.value == index;
      return GestureDetector(
        onTap: () {
          controller.selectDocumentTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.colorPrimary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.colorPrimary : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      );
    });
  }
}
