import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  TextEditingController messageController = TextEditingController();

  var isHeaderExpanded = false.obs;

  void toggleHeaderExpansion() {
    isHeaderExpanded.value = !isHeaderExpanded.value;
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messages.add(
      ChatMessage(message: text, isSentByMe: true, timestamp: DateTime.now()),
    );

    messageController.clear();

    // Simulate a reply
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(
        ChatMessage(
          message: "Auto reply to: $text",
          isSentByMe: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  // UPATE INFO

  // TRC FORM

  final RxList<String> selectedFlight = <String>[].obs;
  final List<String> flightOptions = [
    "IB 1332 MAD - FRA",
    "LH 789 FRA - JFK",
    "BA 142 LHR - DXB",
    "EK 202 JFK - DXB",
    "QR 001 DOH - LHR",
    "AF 348 CDG - YUL",
    "AA 100 MIA - LAX",
    "DL 303 ATL - AMS",
    "UA 881 ORD - NRT",
    "QF 10 LHR - SYD",
    "NH 12 NRT - LAX",
    "KL 601 AMS - LAX",
    "SU 200 SVO - BKK",
    "CX 708 BKK - HKG",
    "SQ 321 LHR - SIN",
  ];

  final RxList<String> selectedPos = <String>[].obs;
  final RxList<String> selectedLR = <String>[].obs;
  final RxList<String> selectedULD = <String>[].obs;
  final RxList<String> selectedVR = <String>[].obs;

  final List<String> posOptions = ["11", "12", "13", "14"];

  // SSR FORM
  final RxList<String> selectedSsrs = <String>[].obs;
  final List<String> ssrOptions = [
    "AVIH",
    "BBSL",
    "BDGP",
    "BDGR",
    "BIKE",
    "BLDP",
    "BLDR",
    "BLND",
    "BLSC",
    "CBBG",
    "DEAF",
    "DEPA",
  ];

  // ARR FORM
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  Future<void> pickTime(BuildContext context, bool isStart) async {
    final nowUtc = DateTime.now().toUtc();
    final initialTime = TimeOfDay.fromDateTime(nowUtc);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final selectedTime = DateTime.utc(
        nowUtc.year,
        nowUtc.month,
        nowUtc.day,
        picked.hour,
        picked.minute,
      );
      final formattedTime = DateFormat.Hm().format(selectedTime);

      if (isStart) {
        startTimeController.text = formattedTime;
      } else {
        endTimeController.text = formattedTime;
      }
    } else {
      // If user cancels, still show current UTC time
      final formattedNow = DateFormat.Hm().format(nowUtc);
      if (isStart) {
        startTimeController.text = formattedNow;
      } else {
        endTimeController.text = formattedNow;
      }
    }
  }

  // PTS FORM
  final selectedTimeMode = "UTC".obs;
}
