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
            data: {
              "TRC": controller.flightDetail.value?.trc!.trc ?? "--",
              "Mobile No": controller.flightDetail.value?.trc!.mobile ?? "--",
              "TRC RMKS": controller.flightDetail.value?.trc!.remarks ?? "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "A/Data",
            data: {
              "CREW": controller.flightDetail.value?.trc!.crew ?? "--",
              "PANTRY": controller.flightDetail.value?.trc!.pantry ?? "--",
              "CAPTAIN": controller.flightDetail.value?.trc!.captain ?? "--",
              "DOW": controller.flightDetail.value?.trc!.captain ?? "--",
              "DOI": controller.flightDetail.value?.trc!.dow ?? "--",
              "MTOW": controller.flightDetail.value?.trc!.doi ?? "--",
              "RTOW": controller.flightDetail.value?.trc!.rtow ?? "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Fuel Data",
            data: {
              "TAXI+APU": controller.flightDetail.value?.trc!.taxi ?? "--",
              "BLOCK": controller.flightDetail.value?.trc!.block ?? "--",
              "TRIP": controller.flightDetail.value?.trc!.trip ?? "--",
              "EET": controller.flightDetail.value?.trc!.eet ?? "--",
              "TAKE OFF": controller.flightDetail.value?.trc!.takeOff ?? "--",
              "UPLIFTED": controller.flightDetail.value?.trc!.uplifted ?? "--",
              "ALTN": controller.flightDetail.value?.trc!.altn ?? "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "F.O.D",
            data: {
              "Before Arrival": controller.flightDetail.value?.trc!.beforeArrival ?? "--",
              "Before Departure": controller.flightDetail.value?.trc!.beforeDeparture ?? "--",
              "After Departure": controller.flightDetail.value?.trc!.afterDeparture ?? "--",
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
