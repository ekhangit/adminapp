import 'package:dhs_app/screens/flightcomm/chat_screen.dart';
import 'package:dhs_app/screens/flightcomm/widget/flight_card.dart';
import 'package:dhs_app/screens/flightcomm/widget/flight_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/flight/flight_comm_controller.dart';
import '../../utils/app_colors.dart';

class FlightCommScreen extends StatelessWidget {
  const FlightCommScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlightCommController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.colorWhite,
      ),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Flight Comm",
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),

          actions: [
            Obx(() {
              return controller.selectedFlightIndex.value != -1
                  ? PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onSelected: (value) async {
                      if (value == 0) {
                        final index = controller.selectedFlightIndex.value;
                        await controller.toggleFlightFavorite(index);
                        controller.selectedFlightIndex.value = -1;
                      }
                    },
                    itemBuilder: (context) {
                      final index = controller.selectedFlightIndex.value;
                      final isFavorite =
                          controller.flightList[index].isFavorite.value;

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
          child: Obx(
            () => IgnorePointer(
              ignoring: controller.isRefreshing.value,
              child: Stack(
                children: [
                  RefreshIndicator(
                    backgroundColor: AppColors.colorPrimary,
                    color: Colors.white,
                    onRefresh: () async {
                      if (!controller.isFlightCommLoading.value) {
                        await controller.fetchFlightComm(isRefereshing: true);
                      }
                    },
                    child: CustomScrollView(
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
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
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
                                child: Center(
                                  child: Text("No flights available."),
                                ),
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
                                    if (controller.selectedFlightIndex.value ==
                                        -1) {
                                      Get.to(
                                        () => const ChatScreen(),
                                        arguments: flight.id,
                                      );
                                    } else {
                                      controller.selectFlight(index);
                                    }
                                  },
                                  onLongPress:
                                      () => controller.selectFlight(index),
                                  child: FlightCard(
                                    flight: flight,
                                    index: index,
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  // 🔄 Loader Overlay
                  Obx(() {
                    return controller.isRefreshing.value
                        ? Container(color: Colors.black.withValues(alpha: 0.25))
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            ),
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
      color: AppColors.colorWhite,
      // color: Colors.yellow,
      padding: const EdgeInsets.only(top: 12),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(controller.filters.length, (index) {
                  final filter = controller.filters[index];
                  final isSelected = controller.selectedFilter.value == filter;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                      left: index == 0 ? 10 : 0,
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

            // Enhanced version with visual integration
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back arrow
                IconButton(
                  onPressed: () => controller.navigateDate(-1),
                  icon: Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: Colors.grey.shade700,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),

                // Date part
                GestureDetector(
                  onTap: () {
                    // Add date picker
                    _showDatePicker(context, controller);
                  },
                  child: Row(
                    children: [
                      Text(
                        _getDatePart(controller.formattedDateTime.value),
                        style: GoogleFonts.roboto(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent.shade200,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        _getTimePart(controller.formattedDateTime.value),
                        style: GoogleFonts.roboto(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Forward arrow
                IconButton(
                  onPressed: () => controller.navigateDate(1),
                  icon: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.grey.shade700,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                // Time part (outside the container)
              ],
            ),
          ],
        );
      }),
    );
  }

  @override
  double get maxExtent => 100;
  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  void _showDatePicker(
    BuildContext context,
    FlightCommController controller,
  ) async {
    final initialDate = controller.selectedDate.value ?? DateTime.now().toUtc();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.colorPrimary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.colorPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      await controller.handleDateChange(pickedDate);
    }
  }
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
