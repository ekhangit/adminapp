import 'package:asg_app/constant.dart';
import 'package:asg_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class TrcInfo extends StatelessWidget {
  const TrcInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final trc = controller.flightDetail.value?.trc;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          InfoSection(
            data: {
              "Flight No":
                  controller.flightDetail.value?.basicDetails.flightInfo ??
                  '--',
              "Callsign":
                  controller.flightDetail.value?.basicDetails.callSign ?? '--',
              "Date": formatDate(
                controller.flightDetail.value?.basicDetails.date ?? '--',
              ),
              "A/C Type":
                  controller.flightDetail.value?.aircraft?.aircraftType.icao ??
                  '--',
              "A/C Regn": controller.flightDetail.value?.aircraft?.name ?? '--',
              "Gate": controller.flightDetail.value?.basicDetails.gate ?? '--',
              "Stand": controller.flightDetail.value?.basicDetails.pos ?? '--',
              "Baggage Belt":
                  controller.flightDetail.value?.basicDetails.beggageBelt ??
                  '--',
            },
          ),
          const SizedBox(height: 12),
          InfoSection(
            title: "TRC Info",
            data: {
              "TRC": trc?.trc ?? "--",
              "Mobile No": trc?.mobile ?? "--",
              "TRC RMKS": trc?.remarks ?? "--",
            },
          ),
          const SizedBox(height: 12),
          InfoSection(
            title: "A/Data",
            data:
                trc == null
                    ? {"No TRC Data Available": "--"}
                    : {
                      "CREW": trc.crew ?? "--",
                      "PANTRY": trc.pantry ?? "--",
                      "CAPTAIN": trc.captain ?? "--",
                      "DOW":
                          trc.captain ??
                          "--", // Note: This seems duplicated with CAPTAIN
                      "DOI":
                          trc.dow ?? "--", // Note: This seems reversed with DOW
                      "MTOW":
                          trc.doi ?? "--", // Note: This seems reversed with DOI
                      "RTOW": trc.rtow ?? "--",
                    },
          ),
          const SizedBox(height: 12),
          InfoSection(
            title: "Fuel Data",
            data:
                trc == null
                    ? {"No Fuel Data Available": "--"}
                    : {
                      "TAXI+APU": trc.taxi ?? "--",
                      "BLOCK": trc.block ?? "--",
                      "TRIP": trc.trip ?? "--",
                      "EET": trc.eet ?? "--",
                      "TAKE OFF": trc.takeOff ?? "--",
                      "UPLIFTED": trc.uplifted ?? "--",
                      "ALTN": trc.altn ?? "--",
                    },
          ),
          const SizedBox(height: 12),
          InfoSection(
            title: "F.O.D",
            data:
                trc == null
                    ? {"No FOD Data Available": "--"}
                    : {
                      "Before Arrival": trc.beforeArrival ?? "--",
                      "Before Departure": trc.beforeDeparture ?? "--",
                      "After Departure": trc.afterDeparture ?? "--",
                    },
          ),
          const SizedBox(height: 12),
          InfoSection(
            keyColor: Colors.red,
            valueColor: Colors.red,
            title: "Total Onboard",
            data: {
              "PAX":
                  controller.flightDetail.value?.actualPax.totalPax
                      .toString() ??
                  "--",
            },
          ),
        ],
      ),
    );
  }
}
