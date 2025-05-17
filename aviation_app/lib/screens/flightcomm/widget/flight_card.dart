import 'package:aviation_app/models/flight_model.dart';
import 'package:aviation_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant.dart';
import '../../../controllers/flight/flightcomm_controller.dart';
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

      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 0.07.h),
        padding: EdgeInsets.symmetric(horizontal: 1.8.w, vertical: 0.7.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.colorPrimary.withOpacity(0.15)
                  : flight.unseenChatsCount != 0
                  ? Colors.yellow.shade100.withOpacity(0.85)
                  : flight.status == "late"
                  ? Colors.red.withOpacity(0.25)
                  : Colors.white,
          border: Border(
            left: BorderSide(
              color: flight.flightDelayStatus ? Colors.red : Colors.green,
              width: 1.2.w,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flight status icon
            isSelected
                ? Icon(
                  Icons.check_circle,
                  size: 2.8.h,
                  color: AppColors.colorPrimary,
                )
                : Image.asset(
                  flight.isDeparture
                      ? "assets/images/outbound.png"
                      : "assets/images/inbound.png",
                  height: 2.8.h,
                  width: 2.8.h,
                ),
            SizedBox(width: 1.5.w),

            // Flight info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with logo, flight info, star
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCircularImage(
                        imageUrl: flight.airline?.picture ?? "",
                        size: 3.0.h,
                      ),
                      SizedBox(width: 1.8.w),

                      // Flight Details
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 1.6.w,
                          children: [
                            Text(
                              flight.flightInfo,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            _divider(),
                            Text(
                              '${flight.departureAirport.iataCode}-${flight.arrivalAirport.iataCode}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (flight.aircraft != null &&
                                flight.aircraft!.aircraftType != null)
                              _divider(),
                            if (flight.aircraft != null &&
                                flight.aircraft!.aircraftType != null)
                              Text(
                                flight.aircraft!.aircraftType!.icao,
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (flight.aircraft != null) _divider(),
                            if (flight.aircraft != null)
                              Text(
                                flight.aircraft!.name,
                                style: TextStyle(
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
                          // if (flight.duration.isNotEmpty &&
                          //     flight.unreadCount != "0")
                          //   _seenCount(' ${flight.unreadCount} ', Colors.green),
                          SizedBox(width: 0.2.h),

                          // Star Icon
                          Obx(
                            () => Icon(
                              controller.favoriteFlights.contains(index)
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 2.0.h,
                              color:
                                  controller.favoriteFlights.contains(index)
                                      ? Colors.orange
                                      : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 0.1.h),

                  // Time & Duration Row
                  Row(
                    children: [
                      if (flight.isDeparture) ...[
                        if (flight.std != null && flight.std!.isNotEmpty)
                          _timeBlock(
                            "STD",
                            formatFlightTime(flight.std!),
                            Colors.blue.shade700,
                          ),
                        if (flight.std != null && flight.std!.isNotEmpty)
                          SizedBox(width: 2.5.w),
                        if (flight.atd != null && flight.atd!.isNotEmpty)
                          _timeBlock(
                            "ATD",
                            formatFlightTime(flight.atd!),
                            Colors.green.shade700,
                          ),
                      ] else ...[
                        if (flight.sta != null && flight.sta!.isNotEmpty)
                          _timeBlock(
                            "STA",
                            formatFlightTime(flight.sta!),
                            Colors.blue.shade700,
                          ),
                        if (flight.sta != null && flight.sta!.isNotEmpty)
                          SizedBox(width: 2.5.w),
                        if (flight.ata != null && flight.ata!.isNotEmpty)
                          _timeBlock(
                            "ATA",
                            formatFlightTime(flight.ata!),
                            Colors.green.shade700,
                          ),
                      ],
                      SizedBox(width: 2.5.w),
                      if (flight.flightDelays.isNotEmpty &&
                          flight.flightDelays[0].delayType != '-' &&
                          flight.flightDelays[0].delayCode != '-' &&
                          flight.flightDelays[0].delayDate != '-')
                        Text(
                          "${flight.flightDelays[0].delayType}${flight.flightDelays[0].delayCode}/${flight.flightDelays[0].delayDate}",
                          style: TextStyle(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      Spacer(),
                      // if (flight.duration.isNotEmpty)
                      //   Text(
                      //     flight.duration,
                      //     style: TextStyle(
                      //       fontSize: 14.5.sp,
                      //       color:
                      //           flight.status == "late"
                      //               ? Colors.red
                      //               : Colors.green,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      if (flight.unseenChatsCount != 0)
                        _seenCount(
                          ' ${flight.unseenChatsCount} ',
                          Colors.green,
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

  bool _shouldAddSpace(String flightNo) {
    final numericPart = flightNo.replaceAll(RegExp(r'[^0-9]'), '');
    return numericPart.length == 3;
  }

  Widget _divider() => Container(
    width: 0.35.w,
    height: 2.0.h,
    color: Colors.black.withOpacity(0.5),
  );

  Widget _timeBlock(String label, String time, Color color) {
    return Row(
      children: [
        Container(
          width: 7.0.w,
          height: 1.9.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0.5.h),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 1.5.w),
        Text(
          time,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _seenCount(String label, Color color) {
    return Container(
      width: 3.5.w,
      height: 1.7.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(0.5.h),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
