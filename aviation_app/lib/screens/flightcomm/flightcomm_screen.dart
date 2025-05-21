import 'package:aviation_app/screens/flightcomm/chat_screen.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_card.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/flight/flightcomm_controller.dart';
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
          title: const Text(
            "Flight Comm",
            style: TextStyle(color: Colors.white),
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
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // 🔁 Sticky Filter Chips
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _FilterHeaderDelegate(controller),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(() {
                      if (controller.isFlightCommLoading.value) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.85),
                                boxShadow: kElevationToShadow[1],
                                border: Border.all(
                                  color: AppColors.matteBlackColor,
                                  width: 0.05,
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (controller.flightList.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(child: Text("No flights available.")),
                        );
                      }

                      return ListView.separated(
                        itemCount: controller.flightList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder:
                            (context, index) => const Divider(
                              height: 0,
                              thickness: 0.3,
                              color: Colors.grey,
                            ),
                        itemBuilder: (context, index) {
                          final flight = controller.flightList[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (controller.selectedFlightIndex.value == -1) {
                                Get.to(
                                  () => const ChatScreen(),
                                  arguments: flight.id,
                                );
                              } else {
                                controller.selectFlight(index);
                              }
                            },
                            onLongPress: () => controller.selectFlight(index),
                            child: FlightCard(flight: flight, index: index),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),

              // 🔄 Loader Overlay
              Obx(() {
                return controller.isFlightCommLoading2.value
                    ? Container(
                      color: Colors.black.withOpacity(0.1),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.85),
                            boxShadow: kElevationToShadow[1],
                            border: Border.all(
                              color: AppColors.matteBlackColor,
                              width: 0.05,
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                      ),
                    )
                    : const SizedBox.shrink();
              }),
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
      // color: Colors.yellow,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(controller.filters.length, (index) {
                  final filter = controller.filters[index];
                  final isSelected = controller.selectedFilter.value == filter;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 12,
                      left: index == 0 ? 12 : 0,
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

            const SizedBox(height: 12),

            // 🔹 Date-Time
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _getDatePart(controller.formattedDateTime.value),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent.shade200,
                    ),
                  ),
                  const TextSpan(text: '  '), // spacing
                  TextSpan(
                    text: _getTimePart(controller.formattedDateTime.value),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  double get maxExtent => 95;
  @override
  double get minExtent => 95;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

String _getDatePart(String value) {
  final split = value.split(' ');
  if (split.length < 5) return value;
  return '${split[0].replaceAll(',', '')}, ${split[1]} ${split[2]} ${split[3]}';
}

String _getTimePart(String value) {
  final split = value.split(' ');
  if (split.length < 5) return '';
  return '${split[4]} ${split[5]}';
}
