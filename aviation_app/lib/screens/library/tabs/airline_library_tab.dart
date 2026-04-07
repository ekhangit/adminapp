import 'package:aviation_app/screens/library/folder_documents_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flight/airline_controller.dart';
import '../../../controllers/library/library_controller.dart';
import '../../../models/airline_library_model.dart';
import '../../../models/folder_model.dart';
import '../../../utils/app_colors.dart';

class AirlineLibraryTab extends StatelessWidget {
  const AirlineLibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = Get.put(LibraryController());

    // Load airline folders when tab is opened
    if (controller.airlines.isEmpty) {
      controller.loadAirlineFolders();
    }

    return Obx(() {
      if (controller.isAirlinesLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.colorPrimary),
        );
      }

      if (controller.airlines.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.airplanemode_active,
                size: 80,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'No airlines available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.airlines.length,
        itemBuilder: (context, index) {
          final airline = controller.airlines[index];
          // Skip airlines with no name
          if (airline.name == null || airline.name!.isEmpty) {
            return const SizedBox.shrink();
          }
          return _buildAirlineItem(controller, airline);
        },
      );
    });
  }

  Widget _buildAirlineItem(
    LibraryController controller,
    AirlineLibraryModel airline,
  ) {
    // Get airline logo from AirlineController, fallback to API picture
    final airlineController = Get.find<AirlineController>();
    final airlineLogo = airlineController.getAirlineLogoById(airline.id) ?? airline.picture;

    return Obx(() {
      final isExpanded = controller.isAirlineFolderExpanded(airline.id);

      return Card(
        margin: const EdgeInsets.only(bottom: 1),
        elevation: isExpanded ? 4 : 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Column(
          children: [
            InkWell(
              onTap:
                  airline.hasFolders
                      ? () =>
                          controller.toggleAirlineFolderExpansion(airline.id)
                      : null,
              borderRadius: BorderRadius.circular(0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Airline Logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: airlineLogo != null && airlineLogo.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: airlineLogo,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.colorPrimary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  airline.picture != null && airline.picture!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: airline.picture!,
                                          fit: BoxFit.contain,
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                                Icons.image_not_supported_outlined,
                                                size: 28,
                                                color: Colors.grey,
                                              ),
                                        )
                                      : const Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 28,
                                          color: Colors.grey,
                                        ),
                            )
                          : airline.picture != null && airline.picture!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: airline.picture!,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.colorPrimary,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 28,
                                        color: Colors.grey,
                                      ),
                                )
                              : const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                    ),
                    const SizedBox(width: 12),
                    // Airline Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            airline.name ?? 'Unknown Airline',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_outlined,
                                size: 15,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                airline.hasFolders
                                    ? '${airline.folders.length} folders'
                                    : 'No folders',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Expand Icon
                    if (airline.hasFolders)
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.colorPrimary,
                        size: 28,
                      ),
                  ],
                ),
              ),
            ),
            // Folders List (Expanded)
            if (isExpanded && airline.hasFolders)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.grey.shade300),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: airline.folders.length,
                    itemBuilder: (context, index) {
                      final folder = airline.folders[index];
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 32,
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.colorPrimary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.folder_outlined,
                                color: AppColors.colorPrimary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              folder.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              controller.selectedFolder.value = FolderModel(
                                id: folder.id,
                                name: folder.name,
                                subfolders: [],
                              );
                              controller.loadDocumentsByAirlineFolder(
                                folder.id,
                                airline.id,
                              );
                              Get.to(
                                () => FolderDocumentsScreen(
                                  folderName: folder.name,
                                ),
                              );
                            },
                          ),
                          if (index < airline.folders.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 32,
                                right: 16,
                              ),
                              child: Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
