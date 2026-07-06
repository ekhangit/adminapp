import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/library_model.dart';
import '../../../utils/app_colors.dart';

class LibraryItem extends StatelessWidget {
  const LibraryItem({super.key, required this.item, this.onTap});

  final LibraryModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document Icon Section - Fixed Height
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                // Background container
                Container(
                  decoration: BoxDecoration(
                    color:
                        item.isReadAndSign
                            ? Colors.blue.withValues(alpha: 0.15)
                            : AppColors.colorPrimary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),

                // Center icon - different for Read & Sign vs PDF documents
                Center(
                  child:
                      item.isReadAndSign
                          ? Icon(
                            Icons.list_alt_rounded,
                            size: 70,
                            color: Colors.blue.shade600.withValues(alpha: 0.7),
                          )
                          : Icon(
                            Icons.picture_as_pdf,
                            size: 70,
                            color: AppColors.colorPrimary.withValues(
                              alpha: 0.25,
                            ),
                          ),
                ),

                // New badge in top right
                if (item.isNew)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Viewed check icon in top left (only for PDF documents)
                if (!item.isReadAndSign && item.docView)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Expanded(
          //   child: DocumentThumbnail(
          //     // ASSUMPTION: item.filePath holds the local path to your PDF
          //     filePath: item.docUrl,
          //   ),
          // ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.shade200,
          ),

          // Info Section
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Document Name - Always reserve space for 2 lines
                  SizedBox(
                    height: 32, // Fixed height for 2 lines of text
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Station/Edition Number and Issue Date in one row
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Station or Edition Number - Always show to maintain consistent height
                      if (item.station != null && item.station!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.station!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      else if (item.isReadAndSign &&
                          item.userName != null &&
                          item.userName!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.userName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_number_outlined,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                (item.editionNumber != null &&
                                        item.editionNumber!.isNotEmpty)
                                    ? 'Ed. ${item.editionNumber}'
                                    : 'Ed. -',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 2),

                      // Issue Date - Always show to maintain consistent height
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              (item.issueDate != null &&
                                      item.issueDate!.isNotEmpty)
                                  ? item.issueDate!
                                  : '-',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Spacer to fill remaining space
                  const Spacer(),

                  // View button for PDF documents
                  if (!item.isReadAndSign) ...[
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // View List button for Read & Sign documents
                  if (item.isReadAndSign) ...[
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar(
                            'View List',
                            'List viewing functionality coming soon',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.colorPrimary,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.all(10),
                            borderRadius: 8,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'View List',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
