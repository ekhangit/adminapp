import 'dart:developer';

import 'package:aviation_app/services/flightchat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import 'package:intl/intl.dart';

import '../../models/flight_detail_model.dart';

class ChatController extends GetxController {
  final selectedTab = 'Chat'.obs;

  final List<Color> _avatarColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.cyan,
    Colors.pink,
  ];

  Color getAvatarColor(String name) {
    final hash = name.hashCode;
    final index = hash % _avatarColors.length;
    return _avatarColors[index];
  }

  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  TextEditingController messageController = TextEditingController();
  var argument = Get.arguments;

  @override
  void onInit() {
    super.onInit();

    log('[ChatController] argument : $argument');

    fetchFlightChatDetail(argument);

    messages.addAll([
      ChatMessage(
        senderInitial: "J",
        senderName: "James - FRA",
        message: "Arrival info shared below.",
        time: "10:30 AM",
        type: "ARR",
        metadata: {
          'LOFO': 'ABC',
          'LOFO RMKS': 'Arrival remarks included in NOTOC.',
          'START TIME': '19:00',
          'END TIME': '20:00',
        },
      ),
      ChatMessage(
        senderInitial: "A",
        senderName: "Ava - LHR",
        message: "Acknowledged. Please keep an eye on the stand availability.",
        time: "10:31 AM",
      ),
      ChatMessage(
        senderInitial: "L",
        senderName: "Lucas - MAD",
        message: "Sure, I’ll update the NOTOC and push to the shared folder.",
        time: "10:32 AM",
        isSentByMe: true,
      ),
      ChatMessage(
        senderInitial: "J",
        senderName: "James - FRA",
        message: "Copy. Let me know if you need me to send the LIR as well.",
        time: "10:35 AM",
      ),
    ]);
  }

  Rxn<FlightDetailModel> flightDetail = Rxn<FlightDetailModel>();

  Future<void> fetchFlightChatDetail(int flightId) async {
    log('[ChatController] flightId : $flightId');

    try {
      final response = await FlightChatService.instance.flightChatDetail(
        flightId: flightId,
      );

      if (response.isSuccess && response.data != null) {
        flightDetail.value = response.data!;
        log('[ChatController] Flight detail fetched successfully.');
      } else {
        log('[ChatController] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[ChatController] Exception: $e');
      log('[ChatController] Stack: $stack');
    }
  }

  var isHeaderExpanded = false.obs;

  void toggleHeaderExpansion() {
    isHeaderExpanded.value = !isHeaderExpanded.value;
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
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
