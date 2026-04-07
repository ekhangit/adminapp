import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../../utils/app_colors.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File imageFile;
  final Function(File, String) onSend;

  const ImagePreviewScreen({
    super.key,
    required this.imageFile,
    required this.onSend,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  String? selectedType;

  final List<String> fileTypes = [
    'Cargo',
    'Ckin',
    'Docs',
    'Fpln',
    'Fuel',
    'Gate',
    'Lds',
    'Lir',
    'Mics',
    'Ramp'
  ];

  void _showTypeSelectionBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Select File Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Type options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: fileTypes.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final type = fileTypes[index];
                  final isSelected = selectedType == type;

                  return ListTile(
                    onTap: () {
                      setState(() {
                        selectedType = type;
                      });
                      Get.back();
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.colorPrimary.withOpacity(0.1)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color:
                            isSelected ? AppColors.colorPrimary : Colors.grey,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.colorPrimary : Colors.black87,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check,
                            color: AppColors.colorPrimary,
                          )
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Header with close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.black87,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Preview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Image preview
              Expanded(
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.file(widget.imageFile, fit: BoxFit.contain),
                  ),
                ),
              ),

              // Type selection button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.black87,
                child: GestureDetector(
                  onTap: _showTypeSelectionBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedType != null
                            ? Colors.greenAccent
                            : Colors.white30,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedType != null
                              ? Icons.check_circle
                              : Icons.category_outlined,
                          color: selectedType != null
                              ? Colors.greenAccent
                              : Colors.white70,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedType ?? 'Select Type',
                                style: TextStyle(
                                  color: selectedType != null
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 16,
                                  fontWeight: selectedType != null
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              if (selectedType == null)
                                const Text(
                                  'Required before sending',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom action bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: Colors.white60,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Send button
                    Expanded(
                      child: GestureDetector(
                        onTap: selectedType == null
                            ? () {
                                Get.snackbar(
                                  'Type Required',
                                  'Please select a file type before sending',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.orange.shade100,
                                  colorText: Colors.orange.shade900,
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            : () {
                                Get.back();
                                widget.onSend(widget.imageFile, selectedType!);
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: selectedType != null
                                ? appThemeGradientSoft
                                : null,
                            color: selectedType == null
                                ? Colors.white30
                                : null,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Send',
                                style: TextStyle(
                                  color: selectedType != null
                                      ? Colors.white
                                      : Colors.white54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/svg/send.svg',
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  selectedType != null
                                      ? Colors.white
                                      : Colors.white54,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
