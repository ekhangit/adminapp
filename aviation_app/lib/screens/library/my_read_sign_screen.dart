import 'package:aviation_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/library/library_controller.dart';
import '../../utils/app_colors.dart';
import 'widgets/library_new_item.dart';
import 'widgets/library_search_field.dart';

class MyReadAndSignScreen extends StatelessWidget {
  const MyReadAndSignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = Get.put(LibraryController());
    final searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    // Load read and sign documents by employee when screen opens
    controller.loadReadAndSignByEmployee();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.colorPrimary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
          title: const Text(
            'My Read & Sign',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          backgroundColor: AppColors.colorPrimary,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CustomLoader());
          }

          final allItems = controller.readAndSign;

          return Column(
            children: [
              // Search Field
              LibrarySearchField(
                controller: searchController,
                searchQuery: searchQuery,
              ),
              // Documents List
              Expanded(
                child: Obx(() {
                  // Filter items based on search query
                  final filteredItems = searchQuery.value.isEmpty
                      ? allItems
                      : allItems.where((item) {
                          return item.name.toLowerCase().contains(searchQuery.value) ||
                              (item.editionNumber?.toLowerCase().contains(searchQuery.value) ?? false);
                        }).toList();

                  if (allItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_document,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No read & sign documents',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No documents found',
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return LibraryNewItem(item: item);
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
