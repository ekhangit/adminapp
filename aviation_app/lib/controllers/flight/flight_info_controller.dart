import 'dart:developer';

import 'package:aviation_app/models/aircraft_model.dart';
import 'package:aviation_app/models/airline_model.dart';
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
    fetchAircraftTypes(argument);
    fetchAircraftReg(argument);
    fetchAllFlightNoWithFlightId(argument);

    // OCC
    fetchAirline();
    fetchAirport();

    selectedAirlineOcc.listen((airline) {
      print("[selectedAirlineOcc] listen call : $airline");

      if (airline != null && airline.id != 0) {
        fetchFlightNoWithAirlineId(airline.id);
      }
    });
  }

  // TRC

  // Fetch all flight no with id
  RxList<FlightNoModel> getFlightNo = <FlightNoModel>[].obs;

  final Rx<FlightNoModel?> selectedFlightInfoTRC = Rx<FlightNoModel?>(null);

  Future<void> fetchAllFlightNoWithFlightId(int flightId) async {
    try {
      final response = await FlightChatService.instance.allFlightNoWithFlightId(
        flightId: flightId,
      );

      if (response.isSuccess && response.data != null) {
        log('[fetchAllFlightNo] All Flight No fetched successfully.');

        getFlightNo.assignAll(response.data!);
      } else {
        log('[fetchAllFlightNo] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchAllFlightNo] Exception: $e');
      log('[fetchAllFlightNo] Stack: $stack');
    }
  }

  RxList<AircraftTypeModel> aircraftTypes = <AircraftTypeModel>[].obs;
  final Rx<AircraftTypeModel?> selectedAircraft = Rx<AircraftTypeModel?>(null);

  Future<void> fetchAircraftTypes(int flightId) async {
    try {
      final response = await FlightChatService.instance.aircraftTypes(
        flightId: flightId,
      );

      if (response.isSuccess && response.data != null) {
        log('[fetchAircraftTypes] Aircraft types fetched successfully');

        aircraftTypes.assignAll(response.data!);
      } else {
        log('[fetchAircraftTypes] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchAircraftTypes] Exception: $e');
      log('[fetchAircraftTypes] Stack: $stack');
    }
  }

  RxList<AircraftRegModel> aircraftReg = <AircraftRegModel>[].obs;
  final Rx<AircraftRegModel?> selectedAircraftReg = Rx<AircraftRegModel?>(null);

  Future<void> fetchAircraftReg(int flightId) async {
    try {
      final response = await FlightChatService.instance.aircraftReg(
        flightId: flightId,
      );

      if (response.isSuccess && response.data != null) {
        log('[fetchAircraftReg] Aircraft reg fetched successfully');

        aircraftReg.assignAll(response.data!);
      } else {
        log('[fetchAircraftReg] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchAircraftReg] Exception: $e');
      log('[fetchAircraftReg] Stack: $stack');
    }
  }

  // DSR

  // Fetch all flight numbers
  RxList<FlightNoModel> allFlightNos = <FlightNoModel>[].obs;

  final Rx<FlightNoModel?> selectedFlightInfo = Rx<FlightNoModel?>(null);

  Future<void> fetchAllFlightNo() async {
    try {
      final response = await FlightChatService.instance.allFlightNo();

      if (response.isSuccess && response.data != null) {
        log('[fetchAllFlightNo] All Flight No fetched successfully.');

        allFlightNos.assignAll(response.data!);
      } else {
        log('[fetchAllFlightNo] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchAllFlightNo] Exception: $e');
      log('[fetchAllFlightNo] Stack: $stack');
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
      final response = await FlightChatService.instance.sendDsr(payload);

      if (response.isSuccess) {
        log("[FlightInfoController] DSR data submitted successfully.");
      } else {
        log(
          "[FlightInfoController] DSR submission failed: ${response.errorMessage}",
        );
      }
    } catch (e, stack) {
      log("[FlightInfoController] Exception while sending ARR: $e");
      log("[FlightInfoController] Stack: $stack");
    }
  }

  // OCC

  // Fetch airline
  RxList<AirlineModel> getAirline = <AirlineModel>[].obs;

  final Rx<AirlineModel?> selectedAirlineOcc = Rx<AirlineModel?>(null);

  Future<void> fetchAirline() async {
    try {
      final response = await FlightChatService.instance.getAirlines();

      if (response.isSuccess && response.data != null) {
        log('[fetchAirline] All Airline fetched successfully.');

        getAirline.assignAll(response.data!);
      } else {
        log('[fetchAirline] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchAirline] Exception: $e');
      log('[fetchAirline] Stack: $stack');
    }
  }

  RxList<FlightNoModel> getFlightNumbers = <FlightNoModel>[].obs;

  final RxList<FlightNoModel> selectedFlightNumberOCC = <FlightNoModel>[].obs;

  Future<void> fetchFlightNoWithAirlineId(int airlineId) async {
    try {
      final response = await FlightChatService.instance.getAirlineFlightNumber(
        airlineId: airlineId,
      );

      if (response.isSuccess && response.data != null) {
        log(
          '[fetchFlightNoWithAirlineId] fetchFlightNoWithAirlineId fetched successfully.',
        );

        getFlightNumbers.assignAll(response.data!);
      } else {
        log('[fetchFlightNoWithAirlineId] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchFlightNoWithAirlineId] Exception: $e');
      log('[fetchFlightNoWithAirlineId] Stack: $stack');
    }
  }

  RxList<AirportModel> getAirport = <AirportModel>[].obs;

  final RxList<AirportModel> selectedAirportOCC = <AirportModel>[].obs;

  Future<void> fetchAirport() async {
    try {
      final response = await FlightChatService.instance.getAirport();

      if (response.isSuccess && response.data != null) {
        log('[fetchAirport] fetchFlightNoWithAirlineId fetched successfully.');

        getAirport.assignAll(response.data!);
      } else {
        log('[fetchAirport] API Error: ${response.errorMessage}');
      }
    } catch (e, stack) {
      log('[fetchAirport] Exception: $e');
      log('[fetchAirport] Stack: $stack');
    }
  }

  final RxString selectedTypeOCC = ''.obs;

  final List<String> typeOCC = ['DEPARTURE', 'ARRIVAL', 'ALL'];

  TextEditingController occFromController = TextEditingController();
  TextEditingController occToController = TextEditingController();
  TextEditingController boradcastMessageController = TextEditingController();

  Future<void> pickFromDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      occFromController.text = DateFormat(
        'dd MMM yyyy',
      ).format(picked); // e.g., 21 May 2025
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      occToController.text = DateFormat(
        'dd MMM yyyy',
      ).format(picked); // e.g., 21 May 2025
    }
  }

  Future<void> sendOcc() async {
    log("[FlightInfoController] Sending sendOcc data...");

    final payload = {
      "flight_id": argument, // make sure this is correctly set
      "from": occFromController.text,
      "to": occToController.text,
      "airline": selectedAirlineOcc.value?.id,
      "airport": selectedAirportOCC.map((e) => e.id).toList(),
      "flight_no": selectedFlightNumberOCC.map((e) => e.id).toList(),
      "type": selectedTypeOCC.value,
      "broadcast_message": boradcastMessageController.text,
    };

    log("[FlightInfoController] OCC Payload: $payload");

    try {
      final response = await FlightChatService.instance.sendOCC(payload);

      if (response.isSuccess) {
        log("[FlightInfoController] OCC data submitted successfully.");
      } else {
        log(
          "[FlightInfoController] OCC submission failed: ${response.errorMessage}",
        );
      }
    } catch (e, stack) {
      log("[FlightInfoController] Exception while sending ARR: $e");
      log("[FlightInfoController] Stack: $stack");
    }
  }
}
