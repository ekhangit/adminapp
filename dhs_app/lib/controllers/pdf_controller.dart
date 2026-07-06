import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dhs_app/services/library_service.dart';
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
      log('[downloadPDF] Requesting: $pdfUrl');
      final response = await http.get(Uri.parse(pdfUrl));

      // Log exactly what the server returned so failures are diagnosable.
      log('[downloadPDF] Status : ${response.statusCode}');
      log('[downloadPDF] Type   : ${response.headers['content-type']}');
      log('[downloadPDF] Length : ${response.bodyBytes.length} bytes');

      if (response.statusCode != 200) {
        log('[downloadPDF] Non-200 body: ${_previewBody(response.bodyBytes)}');
        errorMessage.value =
            'Failed to load PDF (HTTP ${response.statusCode})';
        return;
      }

      final bytes = response.bodyBytes;

      // A real PDF starts with the magic bytes "%PDF". If the server returned
      // a redirect / HTML login or error page instead, PDFium would just fail
      // to open it (init → destroy with no render), so reject it up front.
      final isPdf = bytes.length > 4 &&
          bytes[0] == 0x25 && // %
          bytes[1] == 0x50 && // P
          bytes[2] == 0x44 && // D
          bytes[3] == 0x46; //  F
      if (!isPdf) {
        log('[downloadPDF] Not a PDF. First bytes: ${_previewBody(bytes)}');
        errorMessage.value = 'The server did not return a valid PDF file.';
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      // Unique filename per document so a previously cached file is never reused.
      final file = File('${dir.path}/document_$libraryId.pdf');
      await file.writeAsBytes(bytes);

      log('[downloadPDF] Saved ${bytes.length} bytes to ${file.path}');
      localFilePath.value = file.path;
    } catch (e) {
      log('[downloadPDF] error: $e');
      errorMessage.value = "Failed to load PDF: $e";
    }
  }

  /// Decode the first chunk of a response body as text for logging (e.g. to
  /// reveal an HTML error page hiding behind a .pdf URL).
  String _previewBody(List<int> bytes) {
    try {
      final preview = bytes.length > 300 ? bytes.sublist(0, 300) : bytes;
      return utf8.decode(preview, allowMalformed: true);
    } catch (_) {
      return '<binary ${bytes.length} bytes>';
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
