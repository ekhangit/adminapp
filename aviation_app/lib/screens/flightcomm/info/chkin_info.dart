import 'package:aviation_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../../../controllers/flight/chat_controller.dart';

class ChkinInfo extends StatelessWidget {
  const ChkinInfo({super.key});

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
                controller.flightDetail.value?.basicDetails.date ?? '',
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
            title: "STAFF Info",
            data: {
              "CKIN": "--",
              "GATE": "--",
              "GATE SPVR": "--",
              "SPVR": "--",
              "SPVR RMKS": "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "CKIN Info",
            data: {
              "CKIN Desk No.": "--",
              "CKIN OPENED": "--",
              "GATE OPENED": "--",
              "BOARDING STARTED": "--",
              "ALL MATERIAL SECURED CKIN": "--",
              "No OF CKIN DESK USED": "--",
              "CKIN CLOSED": "--",
              "GATE CLOSED": "--",
              "BOARDING COMPLETED": "--",
              "ALL MATERIAL SECURED GATE": "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Flight Briefing",
            data: {
              "SPECIALS": "--",
              "BOOKING STATUS": "--",
              "SCHEDULE INFO": "--",
              "DOCS CHECK": "--",
              "RAMP (SPECIAL)": "--",
              "OTHERS": "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(title: "Total Onboard", data: {"": ""}),
        ],
      ),
    );
  }
}
