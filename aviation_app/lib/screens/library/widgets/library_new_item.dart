import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/library/library_controller.dart';
import '../../../models/library_model.dart';
import '../../../utils/app_colors.dart';
import '../pdf_viewer.dart';

class LibraryNewItem extends StatelessWidget {
  final LibraryModel item;

  const LibraryNewItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LibraryController>();

    return InkWell(
      onTap: !item.isReadAndSign
          ? () async {
              await Get.to(() => PDFScreen(
                    url: item.docUrl,
                    libraryId: item.id,
                    documentName: item.name,
                  ));
              // Update the item locally to mark as viewed
              item.docView = true;
              controller.safetyDocuments.refresh();
            }
          : () {
              Get.snackbar('View List', 'List viewing functionality coming soon');
            },
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: !item.isReadAndSign && !item.docView
              ? Colors.yellow.shade50
              : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Icon Section
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.isReadAndSign
                    ? Colors.orange.shade50
                    : AppColors.colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.isReadAndSign ? Icons.list_alt : Icons.picture_as_pdf,
                color: item.isReadAndSign
                    ? Colors.orange.shade700
                    : AppColors.colorPrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Issue date and edition
                  Row(
                    children: [
                      // Edition number
                      if (!item.isReadAndSign && item.editionNumber != null && item.editionNumber!.isNotEmpty) ...[
                        Flexible(
                          child: Text(
                            'Ed. ${item.editionNumber}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                      Icon(
                        Icons.calendar_today,
                        size: 11,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.isReadAndSign
                              ? (item.createdAt ?? 'N/A')
                              : (item.issueDate ?? 'N/A'),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isReadAndSign && item.station != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          size: 11,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            item.station!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Arrow icon
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
