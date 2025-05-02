import 'package:aviation_app/screens/flightcomm/chat_screen.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_card.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/flight/flightcomm_controller.dart';
import '../../models/flight_model.dart';
import '../../utils/app_colors.dart';

import 'package:intl/intl.dart';

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
        actions: [
          Obx(() {
            return controller.selectedFlightIndex.value != -1
                ? PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onSelected: (value) {
                    if (value == 0) {
                      controller.toggleFavorite(
                        controller.selectedFlightIndex.value,
                      );
                      Get.snackbar(
                        "Success",
                        "Flight added to favourites!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.7),
                        colorText: Colors.white,
                      );
                      controller.selectedFlightIndex.value =
                          -1; // Reset selection after action
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 20, color: Colors.orange),
                              SizedBox(width: 8),
                              Text("Add to Favourites"),
                            ],
                          ),
                        ),
                      ],
                )
                : const SizedBox();
          }),
        ],
        backgroundColor: AppColors.colorPrimary,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(controller.filters.length, (
                        index,
                      ) {
                        final filter = controller.filters[index];
                        final isSelected =
                            controller.selectedFilter.value == filter;
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 16 : 0,
                            right: 10,
                          ),
                          child: FlightFilterChip(
                            label: filter,
                            isSelected: isSelected,
                            onTap: () => controller.selectFilter(filter),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // 📅 Current DateTime
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _formattedDateTime(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Flight List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                  onTap: () {
                    if (controller.selectedFlightIndex.value == -1) {
                      Get.to(() => ChatScreen());
                    } else {
                      controller.selectFlight(index);
                    }
                  },

                  onLongPress: () => controller.selectFlight(index),

                  child: Column(
                    children: [
                      FlightCard(flight: flights[index], index: index),
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

  // 📅 Format current date-time function
  String _formattedDateTime() {
    final now = DateTime.now().toUtc(); // UTC time
    final formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss \'UTC\'');
    return formatter.format(now);
  }
}
