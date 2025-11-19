import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../../controllers/flight/chat_controller.dart';
import '../../../constant.dart';
import '../../../models/flight_detail_model.dart';

class PicInfo extends StatelessWidget {
  const PicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final picData = controller.flightDetail.value?.picData ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (picData.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No PIC data available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          if (picData.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: picData.length,
              itemBuilder: (context, index) {
                return _buildPicCard(context, picData[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPicCard(BuildContext context, PicData pic) {
    final fullUrl = pic.getAttachmentUrl(apiUrl);
    final fileExtension = pic.getFileExtension();
    final isImage = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'svg',
    ].contains(fileExtension);

    return InkWell(
      onTap: () {
        if (isImage) {
          _showImagePreview(context, fullUrl, pic);
        } else {
          _downloadFile(context, fullUrl, pic);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or file icon
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child:
                    isImage
                        ? CachedNetworkImage(
                          imageUrl: fullUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 32,
                                  ),
                                ),
                              ),
                        )
                        : Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Icon(
                              _getFileIcon(fileExtension),
                              size: 48,
                              color: _getFileColor(fileExtension),
                            ),
                          ),
                        ),
              ),
            ),

            // Footer with user info
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue.shade700,
                    child: Text(
                      pic.user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pic.user.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl, PicData pic) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue.shade700,
                        child: Text(
                          pic.user.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pic.user.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Text(
                              _formatDateTime(pic.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _downloadFile(context, imageUrl, pic),
                        icon: const Icon(Icons.download),
                        tooltip: 'Download',
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Image
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder:
                          (context, url) => Container(
                            height: 300,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            height: 300,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension) {
      case 'pdf':
        return Colors.red.shade400;
      case 'doc':
      case 'docx':
        return Colors.blue.shade400;
      case 'xls':
      case 'xlsx':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  String _getFileTypeLabel(String extension) {
    switch (extension) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'xls':
      case 'xlsx':
        return 'Excel Spreadsheet';
      default:
        return 'File';
    }
  }

  Future<void> _downloadFile(BuildContext context, String url, PicData pic) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          final storageStatus = await Permission.manageExternalStorage.request();
          if (!storageStatus.isGranted) {
            _showMessage(context, 'Storage permission denied', isError: true);
            return;
          }
        }
      }

      // Show downloading message
      _showMessage(context, 'Downloading...', duration: const Duration(seconds: 1));

      // Get file name from URL
      final fileName = url.split('/').last;

      // Determine download path based on platform
      String downloadPath;
      if (Platform.isAndroid) {
        downloadPath = '/storage/emulated/0/Download/$fileName';
      } else if (Platform.isIOS) {
        final directory = Directory('/var/mobile/Media/Downloads');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        downloadPath = '${directory.path}/$fileName';
      } else {
        _showMessage(context, 'Platform not supported', isError: true);
        return;
      }

      // Download file using Dio
      final dio = Dio();
      await dio.download(
        url,
        downloadPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            debugPrint('Download progress: $progress%');
          }
        },
      );

      // Show success message
      _showMessage(context, 'File downloaded successfully');

    } catch (e) {
      debugPrint('Download error: $e');
      _showMessage(context, 'Failed to download file', isError: true);
    }
  }

  void _showMessage(BuildContext context, String message, {bool isError = false, Duration? duration}) {
    Flushbar(
      message: message,
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: isError ? Colors.red : Colors.green,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
