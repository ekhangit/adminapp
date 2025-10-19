import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
import 'widget/common_info_widgets.dart';

class ChkinInfo extends StatelessWidget {
  const ChkinInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final flight = controller.flightDetail.value;
    final capacity = flight?.capacity;
    final actualPax = flight?.actualPax;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Flight Details Card
          InfoCard(
            title: "Flight Details",
            child: FlightDetailsGrid(controller: controller),
          ),

          const SizedBox(height: 16),

          // STAFF Info Card
          InfoCard(
            title: "Staff Info",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: InfoRow("CKIN", "")),
                    Expanded(child: InfoRow("GATE", "")),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: InfoRow("GATE SPVR", "")),
                    Expanded(child: InfoRow("SPVR", "")),
                  ],
                ),
                const SizedBox(height: 12),
                InfoRow(
                  "SPVR RMKS",
                  controller.flightDetail.value?.ckin?.spvrRemark ?? "",
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // CKIN Info Card
          InfoCard(
            title: "CKIN Info",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "Desk No.",
                        controller.flightDetail.value?.ckin?.deskNo ?? "",
                      ),
                    ),
                    Expanded(child: InfoRow("Channel", "")),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "CKIN Opened",
                        controller.flightDetail.value?.ckin?.ckinOpened ?? "",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        "Gate Opened",
                        controller.flightDetail.value?.ckin?.gateOpened ?? "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "Boarding Started",
                        controller.flightDetail.value?.ckin?.bdgStarted ?? "",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        "All Material Secured CKIN",
                        controller.flightDetail.value?.ckin?.securedAtCkin ??
                            "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "No of CKIN Desk Used",
                        controller.flightDetail.value?.ckin?.deskUsed ?? "",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        "CKIN Closed",
                        controller.flightDetail.value?.ckin?.ckinClosed ?? "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "Gate Closed",
                        controller.flightDetail.value?.ckin?.gateClosed ?? "",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        "Boarding Completed",
                        controller.flightDetail.value?.ckin?.bdgCompleted ?? "",
                      ),
                    ),
                  ],
                ),
                InfoRow(
                  "All Material Secured Gate",
                  controller.flightDetail.value?.ckin?.securedAtGate ?? "",
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Flight Briefing Card
          InfoCard(
            title: "Flight Briefing",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "Specials",
                        controller.flightDetail.value?.ckin?.special ?? "",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        "Booking Status",
                        controller.flightDetail.value?.ckin?.bookingStatus ??
                            "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "Schedule Info",
                        controller.flightDetail.value?.ckin?.scheduleInfo ?? "",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        "DOCS Check",
                        controller.flightDetail.value?.ckin?.docsCheck ?? "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        "Ramp (Special)",
                        controller.flightDetail.value?.ckin?.ramp ?? "",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        "Others",
                        controller.flightDetail.value?.ckin?.other ?? "",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Total Onboard Card
          InfoCard(
            title: "Total Onboard",
            child: Column(
              children: [
                InfoRow(
                  "PAX",
                  controller.flightDetail.value?.actualPax.totalPax
                          .toString() ??
                      "",
                  valueColor: Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Configuration Card
          InfoCard(
            title: "Configuration",
            child: Row(
              children: [
                Expanded(child: InfoRow("J", capacity?.j ?? "")),
                Expanded(child: InfoRow("Y", capacity?.y ?? "")),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Booked Pax Card
          InfoCard(
            title: "Booked Pax",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: InfoRow("J", "")),
                    Expanded(child: InfoRow("Y", "")),
                  ],
                ),
                const SizedBox(height: 12),
                InfoRow("INF", ""),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Actual Pax Card
          InfoCard(
            title: "Actual Pax",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: InfoRow("J", actualPax?.paxC ?? "")),
                    Expanded(child: InfoRow("Y", actualPax?.paxY ?? "")),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: InfoRow("INF", actualPax?.paxInf ?? "")),
                    Expanded(child: InfoRow("JMP", actualPax?.paxJmp ?? "")),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pax Type Card
          InfoCard(
            title: "Pax Type",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: InfoRow("A", actualPax?.paxA ?? "")),
                    Expanded(child: InfoRow("M", "")),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: InfoRow("F", "")),
                    Expanded(child: InfoRow("C", actualPax?.paxC ?? "")),
                  ],
                ),
                const SizedBox(height: 12),
                InfoRow("INF", actualPax?.paxInf ?? ""),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Seat Area Card
          InfoCard(
            title: "Seat Area",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: InfoRow("OA", "")),
                    Expanded(child: InfoRow("OB", "")),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: InfoRow("OC", "")),
                    Expanded(child: InfoRow("OD", "")),
                  ],
                ),
                const SizedBox(height: 12),
                InfoRow("OE", ""),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Baggage At Gate Card
          InfoCard(
            title: "Baggage at Gate",
            child: Row(
              children: [
                Expanded(child: InfoRow("PCs", "")),
                Expanded(child: InfoRow("WT", "")),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Baggage At CKIN Card
          InfoCard(
            title: "Baggage at CKIN",
            child: Row(
              children: [
                Expanded(child: InfoRow("PCs", "")),
                Expanded(child: InfoRow("WT", "")),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Catering Card
          InfoCard(
            title: "Catering",
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: InfoRow("J", "")),
                    Expanded(child: InfoRow("Y", "")),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: InfoRow("Total", "")),
                    Expanded(child: InfoRow("INF", "")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
