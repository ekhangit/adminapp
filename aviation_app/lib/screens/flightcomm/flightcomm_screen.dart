import 'package:aviation_app/screens/flightcomm/chat_screen.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_card.dart';
import 'package:aviation_app/screens/flightcomm/widget/show_filters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/flight/flightcomm_controller.dart';
import '../../models/flight_model.dart';
import '../../utils/app_colors.dart';

class FlightcommScreen extends StatelessWidget {
  const FlightcommScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlightCommController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Flight Comm", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.colorPrimary,
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 📌 Subtitle
                    Text(
                      "Showing ${controller.selectedFilter.value}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),

                    // 🔽 Filter Dropdown
                    GestureDetector(
                      onTap: () => showFilterBottomSheet(context, controller),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Text(
                              controller.selectedFilter.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Flight List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                // ChatItemModel chatItem = ChatHelper.getChatItem(index);
                return GestureDetector(
                  onTap: () => Get.to(() => ChatScreen()),

                  child: Column(
                    children: [
                      FlightCard(flight: flights[index]),
                      if (index != flights.length - 1)
                        Divider(color: Colors.grey, height: 0, thickness: 0.25),
                    ],
                  ),
                );
              }, childCount: flights.length),
            ),
          ],
        ),
      ),
    );
  }
}
