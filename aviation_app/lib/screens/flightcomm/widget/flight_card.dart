import 'package:aviation_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flight/flightcomm_controller.dart';
import '../../../models/flight_model.dart';
import '../../../utils/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FlightCard extends StatelessWidget {
  final FlightDetailModel flight;
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
        margin: EdgeInsets.symmetric(vertical: 0.05.h),
        padding: EdgeInsets.symmetric(horizontal: 1.8.w, vertical: 0.7.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.colorPrimary.withOpacity(0.15)
                  : flight.unreadCount != "0"
                  ? Colors.yellow.shade100.withOpacity(0.85)
                  : flight.status == "late"
                  ? Colors.red.withOpacity(0.25)
                  : Colors.white,
          border: Border(
            left: BorderSide(
              color: flight.status == "on-time" ? Colors.green : Colors.red,
              width: 1.2.w,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              final isSelected = controller.selectedFlightIndex.value == index;
              return Icon(
                isSelected ? Icons.check_circle : Icons.flight_takeoff,
                size: 2.8.h,
                color: isSelected ? AppColors.colorPrimary : Colors.black54,
              );
            }),
            SizedBox(width: 1.25.w),

            // Flight Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 1.6.w,
                    children: [
                      CustomCircularImage(
                        imageUrl: flight.airlineLogo,
                        size: 3.2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.3.w),
                        child: Text(
                          "${flight.flightNo}${_shouldAddSpace(flight.flightNo) ? ' ' : ''}",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _divider(),
                      Text(
                        '${flight.fromCode}-${flight.toCode}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _divider(),
                      Text(
                        "A320",
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _divider(),
                      Text(
                        "G-EUYH",
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),

                  // Time Row
                  Row(
                    children: [
                      _timeBlock(
                        "STD",
                        flight.departureTime,
                        Colors.blue.shade700,
                      ),
                      SizedBox(width: 2.5.w),
                      _timeBlock("ATD", flight.arrivalTime, Colors.green),
                      SizedBox(width: 2.5.w),
                      if (flight.status == "late")
                        Text(
                          "DL81/0015",
                          style: TextStyle(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 1.25.w),

            // Right Info Column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(
                  () => Icon(
                    controller.favoriteFlights.contains(index)
                        ? Icons.star
                        : Icons.star_border,
                    size: 2.5.h,
                    color:
                        controller.favoriteFlights.contains(index)
                            ? Colors.orange
                            : Colors.black54,
                  ),
                ),
                SizedBox(height: 0.2.h),
                if (flight.unreadCount != "0")
                  Container(
                    padding: EdgeInsets.all(0.6.h),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      flight.unreadCount,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(height: 0.2.h),
                if (flight.duration.isNotEmpty)
                  Text(
                    flight.duration,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color:
                          flight.status == "late" ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
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
    color: Colors.black87.withOpacity(0.75),
  );

  Widget _timeBlock(String label, String time, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 7.0.w,
          height: 1.8.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0.5.h),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5.sp,
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
}
