import 'package:dhs_app/screens/library/folder_documents_screen.dart';
import 'package:dhs_app/screens/library/my_read_sign_screen.dart';
import 'package:dhs_app/screens/library/read_sign_screen.dart';
import 'package:dhs_app/screens/library/safety_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/library/library_controller.dart';
import '../../../models/folder_model.dart';
import '../../../utils/app_colors.dart';

class GsrmLibraryTab extends StatelessWidget {
  const GsrmLibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = Get.put(LibraryController());

    return Obx(() {
      if (controller.isFoldersLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.colorPrimary),
        );
      }

      return CustomScrollView(
        slivers: [
          // Buttons Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildButton(
                    title: 'Read & Sign',
                    backgroundColor: Colors.blue.shade700,
                    onTap: () {
                      Get.to(() => const ReadSignScreen());
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildButton(
                    title: 'My Read & Sign',
                    backgroundColor: Colors.green.shade700,
                    onTap: () {
                      Get.to(() => const MyReadAndSignScreen());
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSafetyButton(
                    title: 'Safety',
                    onTap: () {
                      Get.to(() => const SafetyScreen());
                    },
                  ),
                ],
              ),
            ),
          ),

          // Folders Section
          if (controller.folders.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No folders available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Folders will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final folder = controller.folders[index];
                  return _buildFolderItem(
                    controller,
                    folder,
                    0,
                    siblings: controller.folders,
                  );
                }, childCount: controller.folders.length),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildButton({
    required String title,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.colorPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:
                borderColor != null
                    ? BorderSide(color: borderColor, width: 2)
                    : BorderSide.none,
          ),
          elevation: 2,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: SafetyStripePainter(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade600,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SafetyStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stripeWidth = 12.0;

    // First fill entire area with yellow
    final yellowPaint =
        Paint()
          ..color = Colors.yellow.shade700
          ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), yellowPaint);

    // Draw black diagonal stripes
    final blackPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    // Draw diagonal stripes from top-left to bottom-right
    for (
      double i = -size.height;
      i < size.width + size.height;
      i += stripeWidth * 2
    ) {
      final stripePath = Path();
      stripePath.moveTo(i, 0);
      stripePath.lineTo(i + stripeWidth, 0);
      stripePath.lineTo(i + stripeWidth + size.height, size.height);
      stripePath.lineTo(i + size.height, size.height);
      stripePath.close();

      canvas.drawPath(stripePath, blackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension GsrmLibraryTabExtension on GsrmLibraryTab {
  Widget _buildFolderItem(
    LibraryController controller,
    FolderModel folder,
    int level, {
    List<FolderModel>? siblings,
  }) {
    return Obx(() {
      final isSelected = controller.selectedFolder.value?.id == folder.id;
      final isExpanded = controller.isFolderExpanded(folder.id);
      final hasSubfolders = folder.hasSubfolders;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 8.0 + (level * 16.0),
              right: 8,
              top: 4,
              bottom: 4,
            ),
            decoration: BoxDecoration(
              color: isExpanded ? Colors.yellow.shade200 : Colors.blue.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
              onTap: () {
                if (hasSubfolders) {
                  // Close sibling folders first
                  if (siblings != null) {
                    final siblingIds = siblings.map((f) => f.id).toList();
                    controller.closeSiblingFolders(siblingIds, folder.id);
                  }
                  controller.toggleFolderExpansion(folder.id);
                } else {
                  controller.selectFolder(folder);
                  Get.to(() => FolderDocumentsScreen(folderName: folder.name));
                }
              },
              title: Text(
                folder.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.colorPrimary : Colors.black87,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.colorPrimary,
                      size: 20,
                    ),
                  if (hasSubfolders) ...[
                    if (isSelected) const SizedBox(width: 8),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Show subfolders if expanded
          if (hasSubfolders && isExpanded)
            ...folder.subfolders.map((subfolder) {
              return _buildFolderItem(
                controller,
                subfolder,
                level + 1,
                siblings: folder.subfolders,
              );
            }).toList(),
        ],
      );
    });
  }
}
