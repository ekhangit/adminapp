import 'package:gsrm_live_app/controllers/flight/airline_controller.dart';
import 'package:gsrm_live_app/models/flight_model.dart';
import 'package:gsrm_live_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';
import '../../../controllers/flight/flight_comm_controller.dart';
import '../../../utils/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

String formatFlightInfo(String info) {
  final regex = RegExp(r'^([A-Z]+)\s?(\d+)$', caseSensitive: false);
  final match = regex.firstMatch(info.trim());

  if (match != null) {
    final airline = match.group(1);
    final number = match.group(2);
    final spaceCount =
        number!.length == 3
            ? 0
            : number.length == 4
            ? 0
            : 0;
    return '$airline $number${' ' * spaceCount}';
  }

  return info;
}

class FlightCard extends StatelessWidget {
  const FlightCard({super.key, required this.flight, required this.index});

  final FlightsModel flight;
  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightCommController>();

    // Get airline controller for cached logos
    final airlineController =
        Get.isRegistered<AirlineController>()
            ? Get.find<AirlineController>()
            : null;

    return Obx(() {
      final isSelected = controller.selectedFlightIndex.value == index;
      final unreadCount = flight.unReadCount.value;
      // final unreadCount = 1;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.75.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.colorPrimary.withValues(alpha: 0.15)
                  : unreadCount != 0
                  ? Color(0xFFFFFDE6)
                  : flight.status == "late"
                  ? Colors.red.withValues(alpha: 0.25)
                  : Colors.white,

          border: Border(
            left: BorderSide(
              color:
                  flight.isDeparture
                      ? (flight.sta!.isEmpty && flight.std!.isEmpty) ||
                              (flight.atd!.isEmpty && flight.ata!.isEmpty)
                          ? Colors.white
                          : flight.departureColor == 'greenBtn'
                          ? Colors.green.shade700
                          : Colors.red.shade700
                      : flight.ata!.isEmpty
                      ? Colors.white
                      : flight.arrivalColor == 'greenBtn'
                      ? Colors.green.shade700
                      : Colors.red.shade700,
              width: 1.2.w,
            ),
          ),
        ),
        child: Row(
          children: [
            isSelected
                ? Icon(
                  Icons.check_circle,
                  size: 2.8.h,
                  color: AppColors.colorPrimary,
                )
                : CustomImage(
                  imageUrl: _getAirlineLogo(flight, airlineController),
                  isNetwork: true,
                  size: 6.5.w,
                  boxFit: BoxFit.fill,
                  isCircular: false,
                ),
            SizedBox(width: 2.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Row (Flight Info + Route + Aircraft)
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Flight number
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatFlightInfo(flight.flightInfo),
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // SizedBox(width: 1.8.w),

                            // Route
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${flight.departureAirport?.iataCode} - ${flight.arrivalAirport?.iataCode}',
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Aircraft type and name (only show if available)
                            Expanded(
                              flex: 3,
                              child: _buildAircraftInfo(flight),
                            ),
                          ],
                        ),
                      ),

                      Obx(
                        () => SvgPicture.asset(
                          'assets/svg/star.svg',
                          width: 1.25.w,
                          height: 1.25.h,
                          color:
                              flight.isFavorite.value
                                  ? Colors.orange
                                  : Colors.grey.shade400.withValues(
                                    alpha: 0.75,
                                  ),
                        ),
                      ),
                    ],
                  ),

                  // unreadCount == 0
                  //     ? SizedBox(height: 0.25.h)
                  //     : SizedBox(height: 0.05.h),
                  SizedBox(height: 0.5.h),

                  // Second Row (Times + Delay aligned with first row end)
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            if (flight.isDeparture) ...[
                              if (flight.std!.isNotEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "STD",
                                    formatFlightTime(flight.std!),
                                    Colors.blue.shade700,
                                  ),
                                ),

                              if (flight.atd!.isNotEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "ATD",
                                    formatFlightTime(flight.atd!),
                                    flight.isDeparture
                                        ? (flight.std!.isEmpty)
                                            ? Colors.blue.shade700
                                            : flight.departureColor ==
                                                'greenBtn'
                                            ? Colors.green.shade700
                                            : Colors.red.shade700
                                        : flight.arrivalColor == 'greenBtn'
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                  ),
                                ),
                              if (flight.atd!.isEmpty &&
                                  flight.sta!.isNotEmpty &&
                                  flight.etd!.isEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "STA",
                                    formatFlightTime(flight.sta!),
                                    Colors.blue.shade700,
                                  ),
                                ),
                              if (flight.atd!.isEmpty && flight.etd!.isNotEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "ETD",
                                    formatFlightTime(flight.etd!),
                                    Colors.amber.shade700,
                                  ),
                                ),
                            ] else ...[
                              if (flight.ata!.isEmpty &&
                                  flight.std!.isNotEmpty &&
                                  flight.eta!.isEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "STD",
                                    formatFlightTime(flight.std!),
                                    Colors.blue.shade700,
                                  ),
                                ),
                              if (flight.sta!.isNotEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "STA",
                                    formatFlightTime(flight.sta!),
                                    Colors.blue.shade700,
                                  ),
                                ),
                              if (flight.ata!.isNotEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "ATA",
                                    formatFlightTime(flight.ata!),
                                    flight.isDeparture
                                        ? flight.departureColor == 'greenBtn'
                                            ? Colors.green.shade700
                                            : Colors.red.shade700
                                        : flight.arrivalColor == 'greenBtn'
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                  ),
                                ),
                              if (flight.ata!.isEmpty && flight.eta!.isNotEmpty)
                                Expanded(
                                  flex: 2,
                                  child: _timeBlock(
                                    "ETA",
                                    formatFlightTime(flight.eta!),
                                    Colors.amber.shade700,
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(width: 0.75.w),

                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            if (flight.flightDelays.isNotEmpty &&
                                flight.flightDelays[0].delayType != '-' &&
                                flight.flightDelays[0].delayCode != '-' &&
                                flight.flightDelays[0].delayDate != '-')
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${flight.flightDelays[0].delayType}${flight.flightDelays[0].delayCode}",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),

                            if ((flight.isDeparture &&
                                    flight.departureDelayMinutes != 0) ||
                                (!flight.isDeparture &&
                                    flight.arrivalDelayMinutes != 0))
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      flight.isDeparture
                                          ? flight.formattedDepartureDelay
                                          : flight.formattedArrivalDelay,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5.sp,
                                        color:
                                            flight.isDeparture
                                                ? flight.departureDelayColor ==
                                                        'text-success'
                                                    ? Colors.green
                                                    : Colors.red
                                                : flight.arrivalDelayColor ==
                                                    'text-success'
                                                ? Colors.green
                                                : Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    SizedBox(width: 2.0.w),

                                    unreadCount == 0
                                        ? SizedBox(width: 2.5.w)
                                        : Container(
                                          padding: EdgeInsets.all(0.45.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.colorSuccess,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$unreadCount',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper method to build aircraft info
  Widget _buildAircraftInfo(FlightsModel flight) {
    final hasAircraftType =
        flight.aircraftType != null &&
        flight.aircraftType!.icao != null &&
        flight.aircraftType!.icao!.isNotEmpty;
    final hasAircraft = flight.aircraft != null;

    // If no aircraft data, return empty container
    if (!hasAircraftType && !hasAircraft) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 0.5.w),

        // Aircraft Type (ICAO)
        if (hasAircraftType)
          Flexible(
            child: Text(
              flight.aircraftType!.icao!,
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1B3668),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Divider (only show if both type and aircraft are present)
        if (hasAircraftType && hasAircraft) ...[
          SizedBox(width: 0.25.w),
          _divider(height: 1.25),
          SizedBox(width: 0.25.w),
        ],

        // Aircraft Name
        if (hasAircraft)
          Flexible(
            child: Text(
              flight.aircraft!.name,
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1B3668),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _divider({
    double width = 0.25,
    double height = 2.0,
    double opacity = .5,
  }) => Container(
    width: width.w,
    height: height.h,
    margin: EdgeInsets.symmetric(horizontal: 1.0.w),
    color: Colors.grey.withValues(alpha: opacity),
  );

  Widget _timeBlock(String label, String time, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 3.0.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.02.h, horizontal: 0.75.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 1.25.w),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              // color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// Get airline logo from cached controller or fallback to flight's airline data
  String _getAirlineLogo(
    FlightsModel flight,
    AirlineController? airlineController,
  ) {
    // First try to get from cached airlines using airlineId
    if (airlineController != null) {
      final cachedLogo = airlineController.getAirlineLogoById(flight.airlineId);
      if (cachedLogo != null && cachedLogo.isNotEmpty) {
        return cachedLogo;
      }
    }

    // Fallback to flight's airline data
    return flight.airline?.mobilePicture ?? "";
  }
}
