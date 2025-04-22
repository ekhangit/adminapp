import 'package:aviation_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';

import '../../../models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final FlightDetailModel flight;

  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            flight.status == "late"
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✈ Airline Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCircularImage(imageUrl: flight.airlineLogo, size: 30),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        flight.fromCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
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
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(width: 1, height: 20, color: Colors.black54),
                  const SizedBox(width: 10),
                  Text(
                    "G-EUYH",
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.shade100.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  flight.flightNo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
              // Duration
              Text(
                flight.duration,
                style: TextStyle(
                  fontSize: 14,
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
