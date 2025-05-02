import 'package:aviation_app/screens/flightcomm/form/widget/multi_select_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class SSRForm extends StatelessWidget {
  const SSRForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiSelectDropdown(
              label: "Select SSR",
              options: controller.ssrOptions,
              selectedItems: controller.selectedSsrs,
            ),
          ],
        ),
      ),
    );
  }
}
