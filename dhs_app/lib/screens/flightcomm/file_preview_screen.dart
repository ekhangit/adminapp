import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../../utils/app_colors.dart';

class FilePreviewScreen extends StatefulWidget {
  final File file;
  final String fileName;
  final String fileSize;
  final Function(File, String) onSend;

  const FilePreviewScreen({
    super.key,
    required this.file,
    required this.fileName,
    required this.fileSize,
    required this.onSend,
  });

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
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

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'txt':
        return Colors.grey;
      case 'zip':
      case 'rar':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

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
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              // Header with close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black87,
                        size: 28,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'File Preview',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // File preview
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // File icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: _getFileColor(widget.fileName).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getFileIcon(widget.fileName),
                            size: 50,
                            color: _getFileColor(widget.fileName),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // File name
                        Text(
                          widget.fileName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // File size
                        Text(
                          widget.fileSize,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Type selection button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFFF5F5F5),
                child: GestureDetector(
                  onTap: _showTypeSelectionBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedType != null
                            ? AppColors.colorPrimary
                            : Colors.grey.shade300,
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
                              ? AppColors.colorPrimary
                              : Colors.grey.shade600,
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
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: selectedType != null
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              if (selectedType == null)
                                Text(
                                  'Required before sending',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade400,
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey.shade700,
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
                                widget.onSend(widget.file, selectedType!);
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: selectedType != null
                                ? appThemeGradientSoft
                                : null,
                            color: selectedType == null
                                ? Colors.grey.shade300
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
                                      : Colors.grey.shade600,
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
                                      : Colors.grey.shade600,
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
