import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
import 'widget/common_info_widgets.dart';

class TrcInfo extends StatelessWidget {
  const TrcInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final trc = controller.flightDetail.value?.trc;

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

          // TRC Info Card
          InfoCard(
            title: "TRC Info",
            child: Column(
              children: [
                InfoRow("TRC", trc?.trc ?? ""),
                InfoRow("TRC RMKS", trc?.remarks ?? ""),
                InfoRow("Mobile No", trc?.mobile ?? ""),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // A/C Data Card
          InfoCard(
            title: "A/C Data",
            child: Column(children: [InfoRow("No TRC Data", "")]),
          ),

          const SizedBox(height: 16),

          // Fuel Data Card
          InfoCard(
            title: "Fuel Data",
            child: Column(children: [InfoRow("Fuel", trc?.block ?? "")]),
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
        ],
      ),
    );
  }
}
