import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/flight_no_model.dart';
import '../../services/flight_chat_service.dart';

import 'package:intl/intl.dart';

class FlightInfoController extends GetxController {
  var argument = Get.arguments;

  @override
  void onInit() {
    super.onInit();

    log('[FlightInfoController] argument : $argument');

    fetchAllFlightNo();
  }

  // DSR

  // Fetch all flight numbers
  RxList<FlightNoModel> allFlightNos = <FlightNoModel>[].obs;

  final Rx<FlightNoModel?> selectedFlightInfo = Rx<FlightNoModel?>(null);

  Future<void> fetchAllFlightNo() async {
    try {
      final response = await FlightChatService.instance.allFlightNo();

      if (response.isSuccess && response.data != null) {
        log('[FlightInfoController] All Flight No fetched successfully.');

        allFlightNos.assignAll(response.data!);
      } else {
        log('[ChatController] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[FlightInfoController] Exception: $e');
      log('[FlightInfoController] Stack: $stack');
    }
  }

  TextEditingController doiController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController paxNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pnrController = TextEditingController();

  Future<void> pickDsrDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      dateController.text = DateFormat(
        'dd MMM yyyy',
      ).format(picked); // e.g., 21 May 2025
    }
  }

  Future<void> pickDoiDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      doiController.text = DateFormat(
        'dd MMM yyyy',
      ).format(picked); // e.g., 21 May 2025
    }
  }

  final RxString selectedCurrency = ''.obs;

  final List<String> currencyList = ['EUR', 'USD', 'GBP'];

  final RxString selectedFOP = ''.obs;

  final List<String> fopList = ['Cash', 'Credit Card', 'Invoice'];

  final RxString selectedServiceType = ''.obs;

  final List<String> serviceTypeList = [
    'TKT/EMD - NEW',
    'TKT/EMD - REISSUE',
    'DATE CHANGE',
    'XSBG',
    'EXST',
  ];

  Future<void> sendDsr() async {
    log("[FlightInfoController] Sending DSR data...");

    final payload = {
      "flight_id": argument, // make sure this is correctly set
      "flight_no": selectedFlightInfo.value?.id,
      "doi": doiController.text,
      "date": dateController.text,
      "pax_name": paxNameController.text,
      "currency": selectedCurrency.value,
      "amount": amountController.text,
      "pnr": pnrController.text,
      "fop": selectedFOP.value,
      "service_type": selectedServiceType.value,
    };

    log("[FlightInfoController] DSR Payload: $payload");

    try {
      // final response = await FlightChatService.instance.sendDsr(payload);

      // if (response.isSuccess) {
      //   log("[FlightInfoController] DSR data submitted successfully.");
      // } else {
      //   log("[FlightInfoController] DSR submission failed: ${response.errorMessage}");
      // }
    } catch (e, stack) {
      log("[FlightInfoController] Exception while sending ARR: $e");
      log("[FlightInfoController] Stack: $stack");
    }
  }
}
