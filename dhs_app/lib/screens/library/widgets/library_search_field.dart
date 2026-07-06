import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';

class LibrarySearchField extends StatelessWidget {
  final TextEditingController controller;
  final RxString searchQuery;

  const LibrarySearchField({
    super.key,
    required this.controller,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Obx(
        () => TextField(
          controller: controller,
          onChanged: (value) {
            searchQuery.value = value.toLowerCase();
          },
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.colorPrimary,
            ),
            suffixIcon: searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      controller.clear();
                      searchQuery.value = '';
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
