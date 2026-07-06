import 'package:dhs_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/library/library_controller.dart';
import 'library_new_item.dart';

class DocumentView extends StatelessWidget {
  const DocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = Get.find<LibraryController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CustomLoader());
      }

      final documents = controller.documents;
      final readAndSign = controller.readAndSign;
      final allItems = [...documents, ...readAndSign];

      if (allItems.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open_outlined,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'No documents available',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                'Documents will appear here',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          final item = allItems[index];
          return LibraryNewItem(item: item);
        },
      );
    });
  }
}
