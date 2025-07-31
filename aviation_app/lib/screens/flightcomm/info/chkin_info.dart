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
    final flight = controller.flightDetail.value;
    final capacity = flight?.capacity;
    final actualPax = flight?.actualPax;

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
                  controller.flightDetail.value?.aircraftType!.icao ??
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
              "SPVR RMKS":
                  controller.flightDetail.value?.ckin?.spvrRemark ?? "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "CKIN Info",
            data: {
              "CKIN Desk No.":
                  controller.flightDetail.value?.ckin?.deskNo ?? "--",
              "CKIN OPENED":
                  controller.flightDetail.value?.ckin?.ckinOpened ?? "--",
              "GATE OPENED":
                  controller.flightDetail.value?.ckin?.gateOpened ?? "--",
              "BOARDING STARTED":
                  controller.flightDetail.value?.ckin?.bdgStarted ?? "--",
              "ALL MATERIAL SECURED CKIN":
                  controller.flightDetail.value?.ckin?.securedAtCkin ?? "--",
              "No OF CKIN DESK USED":
                  controller.flightDetail.value?.ckin?.deskUsed ?? "--",
              "CKIN CLOSED":
                  controller.flightDetail.value?.ckin?.ckinClosed ?? "--",
              "GATE CLOSED":
                  controller.flightDetail.value?.ckin?.gateClosed ?? "--",
              "BOARDING COMPLETED":
                  controller.flightDetail.value?.ckin?.bdgCompleted ?? "--",
              "ALL MATERIAL SECURED GATE":
                  controller.flightDetail.value?.ckin?.securedAtGate ?? "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Flight Briefing",
            data: {
              "SPECIALS": controller.flightDetail.value?.ckin?.special ?? "--",
              "BOOKING STATUS":
                  controller.flightDetail.value?.ckin?.bookingStatus ?? "--",
              "SCHEDULE INFO":
                  controller.flightDetail.value?.ckin?.scheduleInfo ?? "--",
              "DOCS CHECK":
                  controller.flightDetail.value?.ckin?.docsCheck ?? "--",
              "RAMP (SPECIAL)":
                  controller.flightDetail.value?.ckin?.ramp ?? "--",
              "OTHERS": controller.flightDetail.value?.ckin?.other ?? "--",
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
          SizedBox(height: 12),
          InfoSection(
            title: "Configuration",
            data: {"J": capacity?.j ?? "--", "Y": capacity?.y ?? "--"},
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Booked Pax",
            data: {
              "J": "--", // Replace with actual booked J if available
              "Y": "--", // Replace with actual booked Y if available
              "INF": "--", // Replace with actual booked INF if available
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Actual Pax",
            data: {
              "J": actualPax?.paxC ?? "--",
              "Y": actualPax?.paxY ?? "--",
              "INF": actualPax?.paxInf ?? "0",
              "JMP": actualPax?.paxJmp ?? "--",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Pax Type",
            data: {
              "A": actualPax?.paxA ?? "--",
              "M": "--", // Replace with actual M if available
              "F": "--", // Replace with actual F if available
              "C": actualPax?.paxC ?? "--",
              "INF": actualPax?.paxInf ?? "0",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Seat Area",
            data: {"OA": "--", "OB": "--", "OC": "--", "OD": "--", "OE": "--"},
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Baggage At Gate",
            data: {"PCs": "--", "WT": "--"},
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Baggage At CKIN",
            data: {"PCs": "--", "WT": "--"},
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Catering",
            data: {"J": "--", "Y": "--", "Total": "--", "INF": "--"},
          ),
        ],
      ),
    );
  }
}
