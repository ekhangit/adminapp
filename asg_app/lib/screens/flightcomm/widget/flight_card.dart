import 'package:asg_app/models/flight_model.dart';
import 'package:asg_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';
import '../../../controllers/flight/flight_comm_controller.dart';
import '../../../utils/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FlightCard extends StatelessWidget {
  final FlightsModel flight;
  final int index;

  const FlightCard({super.key, required this.flight, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightCommController>();

    return Obx(() {
      final isSelected = controller.selectedFlightIndex.value == index;
      final unreadCount = flight.unReadCount.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 0.07.h),
        padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.4.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.colorPrimary.withValues(alpha: 0.15)
                  : unreadCount != 0
                  ? Colors.yellow.shade100.withValues(alpha: 0.85)
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flight status icon
            // isSelected
            //     ? Icon(
            //       Icons.check_circle,
            //       size: 2.2.h,
            //       color: AppColors.colorPrimary,
            //     )
            //     :
            // Image.asset(
            //       flight.isDeparture
            //           ? "assets/images/outbound.png"
            //           : "assets/images/inbound.png",
            //       height: 2.2.h,
            //       width: 2.2.h,
            //     ),
            CustomImage(
              imageUrl: flight.airline?.mobilePicture ?? "",
              size: 3.5.h,
              boxFit: BoxFit.fill,
              isCircular: false,
              borderRadius: 4.0,
            ),
            SizedBox(width: 2.2.w),

            // Flight info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with logo, flight info, star
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CustomImage(
                      //   imageUrl: flight.airline?.mobilePicture ?? "",
                      //   size: 3.5.h,
                      //   boxFit: BoxFit.fill,
                      //   isCircular: false,
                      // ),
                      // SizedBox(width: 2.0.w),

                      // Flight Details
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 1.6.w,
                          children: [
                            SizedBox(
                              width: 16.w,
                              child: Text(
                                formatFlightInfo(flight.flightInfo),
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _divider(opacity: .7),
                            SizedBox(
                              width: 19.w,
                              child: Text(
                                '${flight.departureAirport?.iataCode}-${flight.arrivalAirport?.iataCode}',
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (flight.aircraftType!.icao!.isNotEmpty)
                              _divider(height: 1.7),
                            if (flight.aircraftType!.icao!.isNotEmpty)
                              Text(
                                flight.aircraftType!.icao!,
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (flight.aircraft != null) _divider(height: 1.7),
                            if (flight.aircraft != null)
                              Text(
                                flight.aircraft!.name,
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (unreadCount != 0)
                            _seenCount(' $unreadCount ', Colors.green),
                          SizedBox(width: 0.2.h),

                          // Star Icon
                          Obx(
                            () => Icon(
                              flight.isFavorite.value
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 2.0.h,
                              color:
                                  flight.isFavorite.value
                                      ? Colors.orange
                                      : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 0.2.h),

                  // Time & Duration Row
                  Row(
                    children: [
                      if (flight.isDeparture) ...[
                        if (flight.std!.isNotEmpty)
                          _timeBlock(
                            "STD",
                            formatFlightTime(flight.std!),
                            Colors.blue.shade700,
                          ),

                        if (flight.std!.isNotEmpty) SizedBox(width: 2.5.w),
                        if (flight.atd!.isNotEmpty)
                          _timeBlock(
                            "ATD",
                            formatFlightTime(flight.atd!),
                            flight.isDeparture
                                ? (flight.std!.isEmpty)
                                    ? Colors.blue.shade700
                                    : flight.departureColor == 'greenBtn'
                                    ? Colors.green.shade700
                                    : Colors.red.shade700
                                : flight.arrivalColor == 'greenBtn'
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        if (flight.atd!.isEmpty &&
                            flight.sta!.isNotEmpty &&
                            flight.eta!.isEmpty)
                          _timeBlock(
                            "STA",
                            formatFlightTime(flight.sta!),
                            Colors.blue.shade700,
                          ),
                        if (flight.atd!.isEmpty && flight.etd!.isNotEmpty)
                          _timeBlock(
                            "ETD",
                            formatFlightTime(flight.eta!),
                            Colors.amber.shade700,
                          ),
                      ] else ...[
                        if (flight.ata!.isEmpty &&
                            flight.std!.isNotEmpty &&
                            flight.eta!.isEmpty)
                          _timeBlock(
                            "STD",
                            formatFlightTime(flight.std!),
                            Colors.blue.shade700,
                          ),
                        if (flight.ata!.isEmpty &&
                            flight.std!.isNotEmpty &&
                            flight.eta!.isEmpty)
                          SizedBox(width: 2.5.w),
                        if (flight.sta!.isNotEmpty)
                          _timeBlock(
                            "STA",
                            formatFlightTime(flight.sta!),
                            Colors.blue.shade700,
                          ),
                        if (flight.sta!.isNotEmpty) SizedBox(width: 2.5.w),
                        if (flight.ata!.isNotEmpty)
                          _timeBlock(
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
                        if (flight.ata!.isEmpty && flight.eta!.isNotEmpty)
                          _timeBlock(
                            "ETA",
                            formatFlightTime(flight.eta!),
                            Colors.amber.shade700,
                          ),
                      ],
                      SizedBox(width: 2.0.w),
                      if (flight.flightDelays.isNotEmpty &&
                          flight.flightDelays[0].delayType != '-' &&
                          flight.flightDelays[0].delayCode != '-' &&
                          flight.flightDelays[0].delayDate != '-')
                        Text(
                          "${flight.flightDelays[0].delayType}${flight.flightDelays[0].delayCode}/${flight.flightDelays[0].delayDate}",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),

                      Expanded(child: SizedBox()),
                      if ((flight.isDeparture &&
                              flight.departureDelayMinutes != 0) ||
                          (!flight.isDeparture &&
                              flight.arrivalDelayMinutes != 0))
                        Text(
                          flight.isDeparture
                              ? flight.formattedDepartureDelay
                              : flight.formattedArrivalDelay,
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 13.5.sp,
                            color:
                                flight.isDeparture
                                    ? flight.departureDelayColor ==
                                            'text-success'
                                        ? Colors.green
                                        : Colors.red
                                    : flight.arrivalDelayColor == 'text-success'
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if ((flight.isDeparture &&
                              flight.departureDelayMinutes != 0) ||
                          (!flight.isDeparture &&
                              flight.arrivalDelayMinutes != 0))
                        SizedBox(width: 0.5.w),
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

  Widget _divider({
    double width = 0.35,
    double height = 2.0,
    double opacity = .5,
  }) => Container(
    width: width.w,
    height: height.h,
    color: Colors.black.withValues(alpha: opacity),
  );

  Widget _timeBlock(String label, String time, Color color) {
    return Row(
      children: [
        Container(
          // width: 7.0.w,
          // height: 2.0.h,
          padding: EdgeInsets.symmetric(vertical: 0.01.h, horizontal: 0.5.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0.35.h),
          ),
          child: Text(
            label,
            style: GoogleFonts.robotoCondensed(
              fontSize: 12.5.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 1.5.w),
        Text(
          time,
          style: GoogleFonts.robotoCondensed(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _seenCount(String label, Color color) {
    return Container(
      width: 3.5.w,
      height: 1.75.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(0.55.h),
      ),
      child: Text(
        label,
        style: GoogleFonts.robotoCondensed(
          fontSize: 11.5.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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
}
