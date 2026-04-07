import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import '../../controllers/pdf_controller.dart';

class PDFScreen extends StatefulWidget {
  final String url;
  final int libraryId;
  final String? documentName;

  const PDFScreen({
    super.key,
    required this.url,
    required this.libraryId,
    this.documentName,
  });

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late final PDFController controller;

  @override
  void initState() {
    super.initState();
    // Use unique tag to ensure fresh controller instance for each PDF
    controller = Get.put(
      PDFController(
        pdfUrl: widget.url,
        libraryId: widget.libraryId,
        documentName: widget.documentName,
      ),
      tag: widget.url,
    );
  }

  @override
  void dispose() {
    // Delete controller when screen is disposed
    Get.delete<PDFController>(tag: widget.url);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Document"),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
                icon: controller.isDownloading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      )
                    : const Icon(Icons.download),
                onPressed: controller.isDownloading.value
                    ? null
                    : () => controller.downloadPDFToDevice(),
                tooltip: 'Download PDF',
              )),
        ],
      ),
      body: Obx(() {
        if (controller.localFilePath.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            PDFView(
              filePath: controller.localFilePath.value,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: controller.currentPage.value,
              fitPolicy: FitPolicy.BOTH,
              backgroundColor: Colors.white,
              onRender: controller.onRender,
              onError: controller.onError,
              onPageError: controller.onPageError,
              onViewCreated: controller.onViewCreated,
              onPageChanged: controller.onPageChanged,
            ),

            // Loading + Error Handling
            if (!controller.isReady.value &&
                controller.errorMessage.value.isEmpty)
              const Center(child: CircularProgressIndicator()),

            if (controller.errorMessage.value.isNotEmpty)
              Center(
                child: Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      }),
    );
  }
}
