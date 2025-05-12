import 'package:aviation_app/screens/flightcomm/chat_screen.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_card.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/flight/flightcomm_controller.dart';
import '../../models/flight_model.dart';
import '../../utils/app_colors.dart';

class FlightcommScreen extends StatelessWidget {
  const FlightcommScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlightCommController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.colorWhite,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              const Text("Flight Comm", style: TextStyle(color: Colors.white)),
              SizedBox(height: 1.5),
              Obx(
                () => Text(
                  controller.formattedDateTime.value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            Obx(() {
              final isFavorite = controller.favoriteFlights.contains(
                controller.selectedFlightIndex.value,
              );

              return controller.selectedFlightIndex.value != -1
                  ? PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
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

                        // Utils.showFlushbar(
                        //   Get.context!,
                        //   "Added to My Flight!",
                        //   backgroundColor: AppColors.colorSuccess,
                        // );
                        controller.selectedFlightIndex.value = -1;
                      }
                    },
                    itemBuilder: (context) {
                      final isFavorite = controller.favoriteFlights.contains(
                        controller.selectedFlightIndex.value,
                      );
                      return [
                        PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(
                                isFavorite ? Icons.star_border : Icons.star,
                                size: 20,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isFavorite
                                    ? "Remove from My Flight"
                                    : "Add to My Flight",
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  )
                  : const SizedBox();
            }),
          ],
          backgroundColor: AppColors.colorPrimary,
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // 🔁 Sticky Filter Chips
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterHeaderDelegate(controller),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 5)),

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
                          Divider(
                            color: Colors.grey,
                            height: 0,
                            thickness: 0.25,
                          ),
                      ],
                    ),
                  );
                }, childCount: flights.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final FlightCommController controller;

  _FilterHeaderDelegate(this.controller);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(controller.filters.length, (index) {
              final filter = controller.filters[index];
              final isSelected = controller.selectedFilter.value == filter;
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 10),
                child: FlightFilterChip(
                  label: filter,
                  isSelected: isSelected,
                  onTap: () => controller.selectFilter(filter),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  @override
  double get maxExtent => 66;
  @override
  double get minExtent => 66;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
