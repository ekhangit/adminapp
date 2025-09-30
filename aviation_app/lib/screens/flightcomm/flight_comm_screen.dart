import 'package:aviation_app/screens/flightcomm/chat_screen.dart';
import 'package:aviation_app/screens/flightcomm/widget/flight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
              if (controller.isSearching.value) {
                return const SizedBox.shrink();
              }

              return Row(
                children: [
                  // Search icon
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => controller.toggleSearch(),
                  ),

                  // More options menu (only show when not in search mode and flight is selected)
                  controller.selectedFlightIndex.value != -1
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
                                  SvgPicture.asset(
                                    'assets/svg/star.svg',
                                    width: 15,
                                    height: 15,
                                    color:
                                        isFavorite
                                            ? Colors.grey.shade300.withAlpha(
                                              191,
                                            ) // 0.75 alpha
                                            : Colors.orange,
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
                      : const SizedBox(),
                ],
              );
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
                  Column(
                    children: [
                      // Search bar (shown when searching)
                      Obx(() {
                        return controller.isSearching.value
                            ? Container(
                              padding: const EdgeInsets.all(12),
                              color: AppColors.colorWhite,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {},
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: controller.searchController,
                                      autofocus: true,
                                      cursorColor: AppColors.colorPrimary,
                                      decoration: InputDecoration(
                                        hintText: 'Search flights...',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                      ),
                                      onChanged:
                                          (value) =>
                                              controller.searchFlights(value),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    onPressed: () => controller.toggleSearch(),
                                  ),
                                ],
                              ),
                            )
                            : const SizedBox.shrink();
                      }),

                      Expanded(
                        child: NotificationListener(
                          onNotification: (scrollNotification) {
                            return true;
                          },
                          child: RefreshIndicator(
                            backgroundColor: AppColors.colorPrimary,
                            color: Colors.white,
                            onRefresh: () async {
                              if (!controller.isFlightCommLoading.value) {
                                await controller.fetchFlightComm(
                                  isRefereshing: true,
                                );
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
                                        padding: EdgeInsets.symmetric(
                                          vertical: 60,
                                        ),
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
                                                color:
                                                    AppColors.matteBlackColor,
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

                                    final displayList =
                                        controller.isSearching.value
                                            ? controller.searchResults
                                            : controller.flightList;

                                    if (displayList.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 60,
                                        ),
                                        child: Center(
                                          child: Text(
                                            controller.isSearching.value
                                                ? "No search flights found."
                                                : "No flights available.",
                                          ),
                                        ),
                                      );
                                    }

                                    return ListView.separated(
                                      itemCount: displayList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder:
                                          (context, index) =>
                                              const SizedBox(height: 4.0),
                                      itemBuilder: (context, index) {
                                        final flight = displayList[index];
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (controller
                                                    .selectedFlightIndex
                                                    .value ==
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
                                              () => controller.selectFlight(
                                                index,
                                              ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.15),
                                                  blurRadius: 2.5,
                                                  spreadRadius: 0.50,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: FlightCard(
                                              flight: flight,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
      // padding: EdgeInsets.symmetric(vertical: 2),
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date row - placed first
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => controller.navigateDate(-1),
                    child: SvgPicture.asset(
                      'assets/svg/arrow_left.svg',
                      width: 18,
                      height: 18,
                    ),
                  ),

                  // Date part with even spacing
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showDatePicker(context, controller);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Day (Monday)
                          if (controller.formattedDateTime.value.isNotEmpty)
                            Text(
                              _getWeekdayName(
                                (controller.selectedDate.value ??
                                        DateTime.now().toUtc())
                                    .weekday,
                              ),
                              style: GoogleFonts.roboto(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),

                          // Date (Nov 18, 2025)
                          Text(
                            _getFormattedDate(
                              controller.selectedDate.value ??
                                  DateTime.now().toUtc(),
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),

                          // Time (16:55:54 UTC)
                          if (controller.formattedDateTime.value.isNotEmpty)
                            Text(
                              _getTimePart(controller.formattedDateTime.value),

                              style: GoogleFonts.roboto(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => controller.navigateDate(1),
                    child: SvgPicture.asset(
                      'assets/svg/arrow_right.svg',
                      width: 18,
                      height: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs with SVG icons
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildFilterTab(
                    context: context,
                    label: "All",
                    iconPath: 'assets/svg/all_flight.svg',
                    isSelected: controller.selectedFilter.value == "All",
                    onTap: () => controller.selectFilter("All"),
                  ),
                  _buildFilterTab(
                    context: context,
                    label: "Arrival",
                    iconPath: 'assets/svg/arrival_flight.svg',
                    isSelected: controller.selectedFilter.value == "Arrivals",
                    onTap: () => controller.selectFilter("Arrivals"),
                  ),

                  _buildFilterTab(
                    context: context,
                    label: "Departures",
                    iconPath: 'assets/svg/departure_flight.svg',
                    isSelected: controller.selectedFilter.value == "Departures",
                    onTap: () => controller.selectFilter("Departures"),
                  ),
                  _buildFilterTab(
                    context: context,
                    label: "My Flights",
                    iconPath: 'assets/svg/my_flight.svg',
                    isSelected: controller.selectedFilter.value == "My Flights",
                    onTap: () => controller.selectFilter("My Flights"),
                  ),
                  _buildFilterTab(
                    context: context,
                    label: "Canceled",
                    iconPath: 'assets/svg/cancel_flight.svg',
                    isSelected: controller.selectedFilter.value == "Cancelled",
                    onTap: () => controller.selectFilter("Cancelled"),
                    isCancelledFlight: true,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
    bool? isCancelledFlight = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF003862),
                        Color.fromARGB(255, 78, 135, 179),
                      ],
                      stops: [0.0, 0.95],
                    )
                    : null,
            color: isSelected ? null : Color(0xFFF5F5F5),
            border: Border(
              right: BorderSide(color: Colors.grey.shade300, width: 0.75),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG icon
              SvgPicture.asset(
                iconPath,
                width: 14,
                height: 14,
                color:
                    isCancelledFlight!
                        ? Colors.red
                        : isSelected
                        ? Colors.white
                        : Colors.grey.shade600,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color:
                      isCancelledFlight
                          ? Colors.red
                          : isSelected
                          ? Colors.white
                          : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
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

// Format date as "Nov 18, 2025"
String _getFormattedDate(DateTime date) {
  final month = _getMonthAbbreviation(date.month);
  final day = date.day;
  final year = date.year;

  return '$month $day, $year';
}

String _getMonthAbbreviation(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}

String _getWeekdayName(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

String _getTimePart(String value) {
  final split = value.split(' ');
  if (split.length < 5) return '';
  return '${split[4]} ${split[5]}';
}
