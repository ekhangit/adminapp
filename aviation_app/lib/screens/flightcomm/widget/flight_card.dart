import 'package:aviation_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flight/flightcomm_controller.dart';
import '../../../models/flight_model.dart';
import '../../../utils/app_colors.dart';

class FlightCard extends StatelessWidget {
  final FlightDetailModel flight;
  final int index;

  const FlightCard({super.key, required this.flight, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightCommController>();

    return Container(
      decoration: BoxDecoration(
        color:
            flight.unreadCount != "0"
                ? Colors.yellow.shade100.withOpacity(0.85)
                : flight.status == "late"
                ? Colors.red.withOpacity(0.25)
                : Colors.white,
        border: Border(
          left: BorderSide(
            color: flight.status == "on-time" ? Colors.green : Colors.red,
            width: 5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            final controller = Get.find<FlightCommController>();
            final isSelected = controller.selectedFlightIndex.value == index;
            return Icon(
              isSelected ? Icons.check_circle : Icons.flight_takeoff,
              size: 24,
              color: isSelected ? AppColors.colorPrimary : Colors.black54,
            );
          }),
          const SizedBox(width: 8),

          // ➡ Main card content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✈ Airline Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomCircularImage(
                          imageUrl: flight.airlineLogo,
                          size: 28,
                        ),
                        const SizedBox(width: 10),

                        Text(
                          flight.flightNo,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(width: 1, height: 20, color: Colors.black54),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Text(
                              flight.fromCode,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(Icons.remove, size: 12),
                            ),
                            Text(
                              flight.toCode,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Container(width: 1, height: 20, color: Colors.black54),
                        const SizedBox(width: 10),
                        Text(
                          "A320",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(width: 1, height: 20, color: Colors.black54),
                        const SizedBox(width: 10),
                        Text(
                          "G-EUYH",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 5),
                  ],
                ),

                const SizedBox(height: 10),

                // 🕒 Times & Duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // STD
                    Row(
                      children: [
                        Row(
                          children: [
                            _badge("STD", Colors.blue.shade700),
                            const SizedBox(width: 10),
                            Text(
                              flight.departureTime,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 30),

                        // ATD
                        Row(
                          children: [
                            _badge("ATD", Colors.green),
                            const SizedBox(width: 10),
                            Text(
                              flight.arrivalTime,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              if (flight.unreadCount != "0")
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    flight.unreadCount,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              SizedBox(height: 2.5),

              Obx(
                () => Icon(
                  controller.favoriteFlights.contains(index)
                      ? Icons.star
                      : Icons.star_border,
                  size: 20,
                  color:
                      controller.favoriteFlights.contains(index)
                          ? Colors.orange
                          : Colors.black54,
                ),
              ),
              SizedBox(height: 2.5),
              if (flight.duration.isNotEmpty)
                Text(
                  flight.duration,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: flight.status == "late" ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
