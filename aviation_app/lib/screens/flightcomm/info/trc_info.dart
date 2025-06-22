import 'package:aviation_app/constant.dart';
import 'package:aviation_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class TrcInfo extends StatelessWidget {
  const TrcInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, bottom: 24),
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
                  controller.flightDetail.value?.aircraft!.aircraftType.icao ??
                  '--',
              "A/C Regn": controller.flightDetail.value?.aircraft!.name ?? '--',
              "Gate": controller.flightDetail.value?.basicDetails.gate ?? '--',
              "Stand": controller.flightDetail.value?.basicDetails.pos ?? '--',
              "Baggage Belt":
                  controller.flightDetail.value?.basicDetails.beggageBelt ??
                  '--',
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "TRC Info",
            data: {"TRC": "--", "Mobile No": "--", "TRC RMKS": "--"},
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "A/Data",
            data: {
              "CREW": "--",
              "PANTRY": "--",
              "CAPTAIN": "--",
              "DOW": "--",
              "DOI": "--",
              "MTOW": "--",
              "RTOW": "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Fuel Data",
            data: {
              "TAXI+APU": "--",
              "BLOCK": "--",
              "TRIP": "--",
              "EET": "--",
              "TAKE OFF": "--",
              "UPLIFTED": "--",
              "ALTN": "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "F.O.D",
            data: {
              "Before Arrival": "--",
              "Before Departure": "--",
              "After Departure": "--",
            },
          ),
          SizedBox(height: 12),
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
