import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../models/flight_model.dart';
import '../../screens/flightcomm/form/widget/form_widgets.dart';
import '../../services/flight_chat_service.dart';
import '../../services/flight_comm_service.dart';
import '../../utils/app_colors.dart';
import '../storage/data_storage_controller.dart';

class PtsController extends GetxController {
  RxString formattedDateTime = ''.obs;
  Timer? _timer;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxBool isLoadingFlights = false.obs;
  final RxBool isLoadingPtsOptions = false.obs;
  final RxBool isSendingPts = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startDateTimeUpdater();
    fetchPtsAllFlights();
  }

  void _startDateTimeUpdater() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  Future<void> navigateDate(int daysToAdd) async {
    final currentDate = selectedDate.value ?? DateTime.now().toUtc();
    final newDate = currentDate.add(Duration(days: daysToAdd));

    final now = DateTime.now().toUtc();
    final minDate = now.subtract(const Duration(days: 30));
    final maxDate = now.add(const Duration(days: 30));

    if (newDate.isBefore(minDate) || newDate.isAfter(maxDate)) {
      return;
    }

    selectedDate.value = newDate;
    _updateTime(); // Add this to update the display
  }

  void _updateTime() {
    final now = DateTime.now().toUtc();
    final dateToShow = selectedDate.value ?? now;

    // Check if we're showing today (either no selection or explicitly selected today)
    final isToday =
        selectedDate.value == null ||
        (selectedDate.value != null &&
            DateUtils.isSameDay(selectedDate.value, now));

    if (isToday) {
      // Always use current time for today
      final formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss \'UTC\'');
      formattedDateTime.value = formatter.format(now); // Use current time
    } else {
      // Show just date for other days
      final formatter = DateFormat('EEEE, dd MMMM yyyy');
      formattedDateTime.value = formatter.format(dateToShow);
    }

    // print('formattedDateTime: ${formattedDateTime.value}');
  }

  // Add this method to convert time based on selected mode
  String getDisplayTime(String time) {
    if (time.isEmpty) return '00:00';

    try {
      final timeFormat = DateFormat('HH:mm');
      final parsedTime = timeFormat.parse(time);

      if (selectedTimeMode.value == 'UTC') {
        // If showing UTC, return as-is (assuming stored as UTC)
        return time;
      } else {
        // Convert UTC to local time for display
        return timeFormat.format(parsedTime.toLocal());
      }
    } catch (e) {
      return time; // Fallback if parsing fails
    }
  }

  // Update this to refresh all time fields when mode changes
  void updateTimeMode(String newMode) {
    selectedTimeMode.value = newMode;
    refreshTimeFields();
    update(); // If using GetBuilder
  }

  void refreshTimeFields() {
    for (final controller in ptsTimeControllers.values) {
      final currentTime = controller.text;
      if (currentTime.isNotEmpty) {
        // This will trigger the UI to update
        controller.text = currentTime;
      }
    }
    ptsTimeControllers.refresh();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Add this method to handle date changes from the UI
  Future<void> handleDateChange(DateTime? newDate) async {
    if (newDate == null) return;

    // Don't fetch if same date is selected again
    if (selectedDate.value != null &&
        DateUtils.isSameDay(selectedDate.value, newDate)) {
      return;
    }

    selectedDate.value = newDate;
    print('[PtsController] Date changed to: ${selectedDate.value}');
  }

  // PTS All Flight

  final Rx<FlightsModelMini?> selectedPtsFlight = Rx<FlightsModelMini?>(null);

  final RxList<FlightsModelMini> ptsAllFlights = <FlightsModelMini>[].obs;

  Future<void> fetchPtsAllFlights() async {
    isLoadingFlights.value = true; // Start loading
    final dateToFetch = selectedDate.value ?? DateTime.now().toUtc();
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateToFetch);

    try {
      final response = await FlightCommService.instance.ptsAllFlightComm(
        date: formattedDate,
      );

      if (response.isSuccess && response.data != null) {
        ptsAllFlights.assignAll(response.data!);
        log(
          '[PtsController] Fetched ${ptsAllFlights.length} flights for $formattedDate',
        );
      } else {
        log('[PtsController] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[PtsController] Exception: $e');
      log('[PtsController] Stack: $stack');
    } finally {
      isLoadingFlights.value = false; // Stop loading
    }
  }

  // PTS

  final selectedTimeMode = "UTC".obs;

  final timeController = TextEditingController();

  RxList<String> getPTSOptions = <String>[].obs;

  final RxMap<String, TextEditingController> ptsTimeControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, String> ptsDropdownSelections = <String, String>{}.obs;

  Future<void> fetchPTSOptions(int flightId) async {
    isLoadingPtsOptions.value = true;
    try {
      // Clear previous selections
      ptsTimeControllers.clear();
      ptsDropdownSelections.clear();

      final response = await FlightChatService.instance.getPTSOption(
        flightId: flightId,
      );

      if (response.isSuccess && response.data != null) {
        log('[fetchPTSOptions] All PTS fetched successfully.');

        final List<String> fields = List<String>.from(response.data!);

        // Assign fetched options
        getPTSOptions.assignAll(fields);

        // Initialize controllers
        for (var field in fields) {
          if (!_isDropdownField(field)) {
            // Initialize with empty string if not already created
            ptsTimeControllers.putIfAbsent(
              field,
              () => TextEditingController(text: ''),
            );
          } else {
            ptsDropdownSelections.putIfAbsent(field, () => '');
          }
        }

        // Update UI
        getPTSOptions.refresh();
        update();
      } else {
        log('[fetchPTSOptions] API Error: ${response.errorMessage}');
        getPTSOptions.clear();
      }
    } catch (e, stack) {
      log('[fetchPTSOptions] Exception: $e');
      log('[fetchPTSOptions] Stack: $stack');
    } finally {
      isLoadingPtsOptions.value = false; // Stop loading
    }
  }

  bool _isDropdownField(String field) {
    return ["jetway/steps", "back_steps_used"].contains(field);
  }

  // Update this method to handle time mode
  void pickTimePTS(String field) {
    final now = DateTime.now();
    final time =
        selectedTimeMode.value == 'UTC'
            ? DateFormat.Hm().format(now.toUtc())
            : DateFormat.Hm().format(now);

    ptsTimeControllers[field]?.text = time;
    ptsTimeControllers.refresh();
    getPTSOptions.refresh();
  }

  // Add this to your FlightInfoController
  void refreshPTSFields() {
    ptsTimeControllers.refresh();
    getPTSOptions.refresh();
  }

  void showManualTimeInput(TextEditingController controller) {
    final textController = TextEditingController(text: controller.text);

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.colorWhite,
        title: const Text('Set Timer'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'HH:MM',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 0.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.colorPrimary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.colorWarning),
            ),
          ),
          keyboardType: TextInputType.datetime,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
            LengthLimitingTextInputFormatter(5),
            TimeInputFormatter(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.colorPrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_validateTime(textController.text)) {
                controller.text = textController.text;

                ptsTimeControllers.refresh();
                getPTSOptions.refresh();
                Get.back();
              } else {
                Get.snackbar(
                  'Invalid Time',
                  'Please enter time in HH:MM format',
                );
              }
            },
            child: const Text(
              'Save',

              style: TextStyle(color: AppColors.colorPrimary),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateTime(String time) {
    final regExp = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regExp.hasMatch(time);
  }

  Map<String, dynamic> _preparePtsPayload({bool forFirebase = false}) {
    final Map<String, dynamic> payloadData = {};

    // Only include flight_id if not for Firebase
    if (!forFirebase) {
      payloadData['flight_id'] = selectedPtsFlight.value?.id ?? 0;
    }

    for (final field in getPTSOptions) {
      final key = field.toLowerCase().replaceAll("/", "_").replaceAll(" ", "_");

      if (_isDropdownField(field)) {
        payloadData[key] = ptsDropdownSelections[field] ?? "";
      } else {
        if (selectedTimeMode.value == 'Local') {
          try {
            final timeFormat = DateFormat('HH:mm');
            final localTime = timeFormat.parse(
              ptsTimeControllers[field]?.text ?? '00:00',
            );
            payloadData[key] = timeFormat.format(localTime.toUtc());
          } catch (e) {
            payloadData[key] = ptsTimeControllers[field]?.text ?? "";
          }
        } else {
          payloadData[key] = ptsTimeControllers[field]?.text ?? "";
        }
      }
    }

    return payloadData;
  }

  Future<void> sendPts() async {
    if (isSendingPts.value) return; // Prevent duplicate submissions
    isSendingPts.value = true;

    try {
      final payloadData = _preparePtsPayload();
      log("[PtsController] Sending PTS data: $payloadData");

      final response = await FlightChatService.instance.sendPts(payloadData);
      if (response.isSuccess) {
        log("[PtsController] PTS data submitted successfully.");
        await sendFirebasePTS(selectedPtsFlight.value!.id.toString());
      } else {
        log("[PtsController] PTS submission failed: ${response.errorMessage}");
        Get.snackbar('Error', 'Failed to send PTS data');
      }
    } catch (e, stack) {
      log("[PtsController] Exception while sending PTS: $e");
      log("[PtsController] Stack: $stack");
      Get.snackbar('Error', 'Failed to send PTS data');
    } finally {
      isSendingPts.value = false; // Ensure this is always set to false
    }
  }

  Future<void> sendFirebasePTS(String flightId) async {
    try {
      final payloadData = _preparePtsPayload(forFirebase: true);
      final currentUser = DataStorageController.to.user;
      final currentUserIdStr = currentUser.id.toString();

      log("[PtsController] Sending PTS to Firebase: $payloadData");

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(flightId)
          .collection('messages')
          .add({
            'sender_id': currentUserIdStr,
            'message': payloadData,
            'message_type': 'pts',
            'read_by': [currentUserIdStr],
            'created_at': FieldValue.serverTimestamp(),
          });

      log("[PtsController] PTS data successfully sent to Firebase");
      Get.snackbar('Success', 'PTS data submitted successfully');
    } catch (e, stack) {
      log("[PtsController] Error sending PTS to Firebase: $e");
      log("[PtsController] Stack: $stack");
      Get.snackbar('Error', 'Failed to send PTS data to Firebase');
      rethrow; // Re-throw to allow sendPts() to handle it
    }
  }
}
