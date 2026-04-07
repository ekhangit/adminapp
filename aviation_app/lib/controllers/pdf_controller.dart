import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:aviation_app/services/library_service.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PDFController extends GetxController {
  final Completer<PDFViewController> pdfViewController =
      Completer<PDFViewController>();

  RxInt totalPages = 0.obs;
  RxInt currentPage = 0.obs;
  RxBool isReady = false.obs;
  RxString errorMessage = ''.obs;
  Rx<String?> localFilePath = Rx<String?>(null);
  RxBool isDownloading = false.obs;

  final String pdfUrl;
  final int libraryId;
  String? documentName;

  PDFController({required this.pdfUrl, required this.libraryId, this.documentName});

  @override
  void onInit() {
    super.onInit();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      final response = await http.get(Uri.parse(pdfUrl));
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/document.pdf");
      await file.writeAsBytes(response.bodyBytes);

      localFilePath.value = file.path;
    } catch (e) {
      log('[downloadPDF] error: $e');
      errorMessage.value = "Failed to load PDF: $e";
    }
  }

  void onRender(int? pages) {
    totalPages.value = pages ?? 0;
    isReady.value = true;
    // Update last viewed when PDF is successfully rendered
    updateLastViewed();
  }

  Future<void> updateLastViewed() async {
    try {
      await LibraryService.instance.updateLastViewedDocument(libraryId);
      log('[updateLastViewed] Successfully updated for library_id: $libraryId');
    } catch (e) {
      log('[updateLastViewed] error: $e');
      // Don't show error to user, just log it
    }
  }

  void onError(dynamic error) {
    errorMessage.value = error.toString();
  }

  void onPageError(int? page, dynamic error) {
    errorMessage.value = '$page: ${error.toString()}';
  }

  void onViewCreated(PDFViewController controller) {
    if (!pdfViewController.isCompleted) {
      pdfViewController.complete(controller);
    }
  }

  void onPageChanged(int? page, int? total) {
    currentPage.value = page ?? 0;
  }

  Future<void> downloadPDFToDevice() async {
    try {
      isDownloading.value = true;

      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar(
            'Permission Denied',
            'Storage permission is required to download PDF',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isDownloading.value = false;
          return;
        }
      }

      // Get the Downloads directory
      Directory? downloadDir;
      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
        if (!await downloadDir.exists()) {
          downloadDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (downloadDir == null) {
        throw Exception('Could not access download directory');
      }

      // Generate filename
      final fileName = documentName != null
          ? '${documentName!.replaceAll(' ', '_')}.pdf'
          : 'document_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final filePath = '${downloadDir.path}/$fileName';

      // Download the file
      final response = await http.get(Uri.parse(pdfUrl));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      isDownloading.value = false;

      Get.snackbar(
        'Download Complete',
        'PDF saved to: ${downloadDir.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      log('[downloadPDFToDevice] PDF saved to: $filePath');
    } catch (e) {
      isDownloading.value = false;
      log('[downloadPDFToDevice] error: $e');
      Get.snackbar(
        'Download Failed',
        'Failed to download PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
