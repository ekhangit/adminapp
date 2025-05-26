import 'dart:developer';

import 'package:aviation_app/controllers/flight/flight_info_controller.dart';
import 'package:aviation_app/services/flight_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import 'package:intl/intl.dart';

import '../../models/flight_detail_model.dart';

class ChatController extends GetxController {
  var argument = Get.arguments;

  @override
  void onInit() {
    super.onInit();

    log('[ChatController] argument : $argument');

    fetchFlightChatDetail(argument);
    fetchFlightChats(argument);
  }

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

  // CHAT FORM
  Future<void> fetchFlightChats(int flightId) async {
    log('[ChatController] flightId : $flightId');

    try {
      final response = await FlightChatService.instance.flightChats(
        flightId: flightId,
      );

      if (response.isSuccess && response.data != null) {
        log('[ChatController] Flight chats fetched successfully.');
        messages.assignAll(response.data!);
      } else {
        log('[ChatController] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[ChatController] Exception: $e');
      log('[ChatController] Stack: $stack');
    }
  }

  // UPATE INFO

  final RxInt selectedIndex = 0.obs;
  final List<String> tabTitles = [
    "TRC",
    "CHECK IN",
    "SSR",
    "ARR",
    "PTS",
    "DSR",
    "FHR",
    "STAFF",
    "OCC",
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
  final TextEditingController lofoController = TextEditingController();
  final TextEditingController lofoRemarksController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController mhbAHLController = TextEditingController();
  final TextEditingController ohdController = TextEditingController();
  final TextEditingController dprController = TextEditingController();

  Future<void> pickTime(bool isStart) async {
    final fixedTime = DateTime.utc(0, 1, 1, 12, 0);
    final formatted = DateFormat.Hm().format(fixedTime);

    if (isStart) {
      startTimeController.text = formatted;
    } else {
      endTimeController.text = formatted;
    }
  }

  void incrementTime(TextEditingController controller, {bool isHour = true}) {
    final now = TimeOfDay.now();
    final parts = controller.text.split(":");

    int hour = int.tryParse(parts[0]) ?? now.hour;
    int minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? now.minute;

    if (isHour) {
      hour = (hour + 1) % 24;
    } else {
      minute = (minute + 5) % 60;
    }

    controller.text =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  void decrementTime(TextEditingController controller, {bool isHour = true}) {
    final now = TimeOfDay.now();
    final parts = controller.text.split(":");

    int hour = int.tryParse(parts[0]) ?? now.hour;
    int minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? now.minute;

    if (isHour) {
      hour = (hour - 1 + 24) % 24;
    } else {
      minute = (minute - 5 + 60) % 60;
    }

    controller.text =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  Future<void> sendArr() async {
    log("[ChatController] Sending ARR data...");

    final payload = {
      "lofo": lofoController.text,
      "lofo_rmks": lofoRemarksController.text,
      "start_time": startTimeController.text,
      "end_time": endTimeController.text,
      "mhb_ahl": mhbAHLController.text,
      "ohd": ohdController.text,
      "dpr": dprController.text,
      "flight_id": argument, // make sure this is correctly set
    };

    log("[ChatController] ARR Payload: $payload");

    try {
      // final response = await FlightChatService.instance.sendArr(payload);

      // if (response.isSuccess) {
      //   log("[ChatController] ARR data submitted successfully.");
      // } else {
      //   log("[ChatController] ARR submission failed: ${response.errorMessage}");
      // }
    } catch (e, stack) {
      log("[ChatController] Exception while sending ARR: $e");
      log("[ChatController] Stack: $stack");
    }
  }

  // PTS FORM
  final selectedTimeMode = "UTC".obs;

  // FHR FORM
  final missedArtg5ExplanationController = TextEditingController();
  final delayExplanationController = TextEditingController();
  final chkInTKGIssueController = TextEditingController();
  final rampCrewDistruptivePaxController = TextEditingController();
  final safetySecuritySystemController = TextEditingController();
  final otherController = TextEditingController();
  final involDeniedBoardingController = TextEditingController();

  Future<void> sendFhr() async {
    log("[ChatController] Sending FHR data...");

    final payload = {
      "MISSED_ARTSG_5_EXPLANATION": missedArtg5ExplanationController.text,
      "DELAY_EXPLANATION": delayExplanationController.text,
      "CHECK-IN/TKTG ISSUES": chkInTKGIssueController.text,
      "RAMP/CREWDISRUPTIVE PAX ETC": rampCrewDistruptivePaxController.text,
      "SAFETY/SECURITY/SYSTEM": safetySecuritySystemController.text,
      "OTHER": otherController.text,
      "INVOL DENIED BOARDING": involDeniedBoardingController.text,
    };

    log("[ChatController] FHR Payload: $payload");

    try {
      // final response = await FlightChatService.instance.sendFhr(payload);

      // if (response.isSuccess) {
      //   log("[ChatController] FHR data submitted successfully.");
      // } else {
      //   log("[ChatController] FHR submission failed: ${response.errorMessage}");
      // }
    } catch (e, stack) {
      log("[ChatController] Exception while sending ARR: $e");
      log("[ChatController] Stack: $stack");
    }
  }

  // Save Changes

  final RxBool saveLoading = false.obs;

  Future<void> saveChanges() async {
    log("[ChatController] Saving changes...");
    saveLoading.value = true;

    final selectedTabTitle = tabTitles[selectedIndex.value];

    final flightInfoController = Get.find<FlightInfoController>();

    try {
      switch (selectedTabTitle) {
        case "ARR":
          await sendArr();
          break;

        case "DSR":
          await flightInfoController.sendDsr();
          break;

        case "FHR":
          await sendFhr();
          break;

        case "OCC":
          await flightInfoController.sendOcc();
          break;

        default:
          log(
            "[ChatController] No save handler defined for tab: $selectedTabTitle",
          );
      }

      log("[ChatController] Changes saved for tab: $selectedTabTitle");
    } catch (e, stack) {
      log("[ChatController] Save exception: $e");
      log("[ChatController] Stack: $stack");
    } finally {
      saveLoading.value = false;
    }
  }
}
