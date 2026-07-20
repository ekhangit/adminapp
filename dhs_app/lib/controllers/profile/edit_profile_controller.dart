import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/emp_profile_model.dart';
import '../../services/profile_service.dart';
import '../storage/data_storage_controller.dart';

class Country {
  final String flag;
  final String name;
  final String dial;
  const Country(this.flag, this.name, this.dial);
}

class EditProfileController extends GetxController {
  static const List<Country> countries = [
    Country('🇩🇪', 'Germany', '+49'),
    Country('🇬🇧', 'United Kingdom', '+44'),
    Country('🇺🇸', 'United States', '+1'),
    Country('🇫🇷', 'France', '+33'),
    Country('🇮🇹', 'Italy', '+39'),
    Country('🇪🇸', 'Spain', '+34'),
    Country('🇳🇱', 'Netherlands', '+31'),
    Country('🇬🇷', 'Greece', '+30'),
    Country('🇹🇷', 'Türkiye', '+90'),
    Country('🇦🇪', 'UAE', '+971'),
    Country('🇮🇳', 'India', '+91'),
    Country('🇵🇰', 'Pakistan', '+92'),
  ];

  // Selected dial code per phone field.
  final RxString mobileCompanyCode = '+49'.obs;
  final RxString mobilePersonalCode = '+49'.obs;
  final RxString phoneCompanyCode = '+49'.obs;
  final RxString emergencyPhoneCode = '+49'.obs;


  // ── Profile text fields ──────────────────────────────────────────────
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final dob = TextEditingController();
  final doj = TextEditingController();
  final mobileCompany = TextEditingController();
  final mobilePersonal = TextEditingController();
  final phoneCompany = TextEditingController();
  final emergencyPhone = TextEditingController();
  final emergencyName = TextEditingController();
  final location = TextEditingController();
  final company = TextEditingController();
  final annualLeave = TextEditingController();

  // ── Detail text fields ───────────────────────────────────────────────
  final taxCode = TextEditingController();
  final passportNo = TextEditingController();
  final passportDoi = TextEditingController();
  final passportDex = TextEditingController();
  final staffNo = TextEditingController();
  final idCardNo = TextEditingController();
  final costCenter = TextEditingController();
  final nationality = TextEditingController();
  final placeOfBirth = TextEditingController();
  final city = TextEditingController();
  final minHours = TextEditingController();
  final maxHours = TextEditingController();
  final dateTermination = TextEditingController();
  final reasonTermination = TextEditingController();
  final address = TextEditingController();
  final preferredDaysOff = TextEditingController();

  // ── Reactive selections ──────────────────────────────────────────────
  final Rxn<String> workType = Rxn<String>();
  final Rxn<String> station = Rxn<String>();
  final Rxn<String> department = Rxn<String>();
  final Rxn<String> position = Rxn<String>();
  final Rxn<String> reportsTo = Rxn<String>();
  final Rxn<String> altReport = Rxn<String>();
  final Rxn<String> contractor = Rxn<String>('No');
  final Rxn<String> gender = Rxn<String>();

  // ── Option lists (populated from the API) ────────────────────────────
  List<String> workTypes = ['Full Time', 'Part Time', 'Contract'];
  List<String> departments = [];
  List<String> positions = [];
  List<String> reportsToList = [];
  List<String> stations = [];
  List<String> locations = [];

  final Rxn<String> locationSel = Rxn<String>();

  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  // name → id lookups + originals (for the update payload).
  int? _userId;
  int? _airportId, _locationId, _departmentId, _positionId, _reportsToId;
  Map<String, int> _airportIds = {},
      _locationIds = {},
      _departmentIds = {},
      _positionIds = {};

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    final userId = DataStorageController.to.user.id;
    final profileRes = await ProfileService.instance.getEmpData(userId);
    final detailRes = await ProfileService.instance.getEmpDetail(userId);

    if (profileRes.isSuccess && profileRes.data != null) {
      _applyProfile(profileRes.data!);
    } else {
      _fallbackFromUser();
    }
    if (detailRes.isSuccess && detailRes.data != null) {
      _applyDetail(detailRes.data!);
    }
    isLoading.value = false;
  }

  void _applyProfile(EmpProfileData p) {
    firstName.text = p.firstName;
    lastName.text = p.lastName;
    fullName.text = p.fullName;
    email.text = p.email;
    dob.text = p.dateOfBirth ?? '';
    doj.text = p.dateOfJoin ?? '';
    mobileCompany.text = p.mobCompany ?? '';
    mobilePersonal.text = p.mobPersonal ?? '';
    phoneCompany.text = p.phoneCompany ?? '';
    emergencyPhone.text = p.emergencyNumber ?? '';
    emergencyName.text = p.emergencyName ?? '';
    location.text = p.location ?? '';
    company.text = p.company ?? '';
    annualLeave.text = p.annualLeave ?? '';

    // Option lists
    departments = p.departmentOptions;
    positions = p.positionOptions;
    reportsToList = p.positionOptions; // reports-to is a role/position
    locations = p.locationOptions;
    stations =
        p.airportOptions.isNotEmpty
            ? p.airportOptions
            : (p.airport != null ? [p.airport!] : []);

    // id lookups + originals
    _userId = p.userId;
    _airportId = p.airportId;
    _locationId = p.locationId;
    _departmentId = p.departmentId;
    _positionId = p.positionId;
    _reportsToId = p.reportsToId;
    _airportIds = p.airportIdByName;
    _locationIds = p.locationIdByName;
    _departmentIds = p.departmentIdByName;
    _positionIds = p.positionIdByName;

    // Selected values
    workType.value = _formatWorkType(p.workType);
    department.value = p.department;
    position.value = p.position;
    reportsTo.value = p.reportsTo;
    altReport.value = p.alternateReportTo;
    station.value = p.airport;
    locationSel.value = p.location;
    gender.value = p.gender;
    if (p.contractor != null && p.contractor!.isNotEmpty) {
      contractor.value = p.contractor;
    }
  }

  void _applyDetail(EmpDetailData d) {
    taxCode.text = d.taxCode ?? '';
    passportNo.text = d.passportNo ?? '';
    passportDoi.text = d.passportDoi ?? '';
    passportDex.text = d.passportDex ?? '';
    staffNo.text = d.staffNo ?? '';
    idCardNo.text = d.idCardNo ?? '';
    costCenter.text = d.costCenter ?? '';
    nationality.text = d.nationality ?? '';
    placeOfBirth.text = d.placeOfBirth ?? '';
    city.text = d.city ?? '';
    minHours.text = d.minHours ?? '';
    maxHours.text = d.maxHours ?? '';
    dateTermination.text = d.dateOfTermination ?? '';
    reasonTermination.text = d.reasonOfTermination ?? '';
    address.text = d.address ?? '';
    preferredDaysOff.text = d.preferredDaysOff ?? '';
  }

  void _fallbackFromUser() {
    final user = DataStorageController.to.user;
    fullName.text = user.name;
    email.text = user.email;
  }

  String? _formatWorkType(String? w) {
    switch (w) {
      case 'full_time':
        return 'Full Time';
      case 'part_time':
        return 'Part Time';
      case 'contract':
        return 'Contract';
      default:
        return w;
    }
  }

  String? _workTypeToApi(String? w) {
    switch (w) {
      case 'Full Time':
        return 'full_time';
      case 'Part Time':
        return 'part_time';
      case 'Contract':
        return 'contract';
      default:
        return w;
    }
  }

  // Empty text → null so blanks aren't sent as ''.
  String? _n(String s) => s.trim().isEmpty ? null : s.trim();

  /// Saves both profile + detail. Returns null on success, else an error message.
  Future<String?> save() async {
    isSaving.value = true;
    try {
      final profileBody = <String, dynamic>{
        'user_id': _userId,
        'first_name': _n(firstName.text),
        'last_name': _n(lastName.text),
        'email': _n(email.text),
        'phone_company': _n(phoneCompany.text),
        'mob_company': _n(mobileCompany.text),
        'mob_personal': _n(mobilePersonal.text),
        'emergency_contact_name': _n(emergencyName.text),
        'emergency_contact_number': _n(emergencyPhone.text),
        'date_of_birth': _n(dob.text),
        'date_of_join': _n(doj.text),
        'airport_id': _airportIds[station.value] ?? _airportId,
        'location_id': _locationIds[locationSel.value] ?? _locationId,
        'department_id': _departmentIds[department.value] ?? _departmentId,
        'position_id': _positionIds[position.value] ?? _positionId,
        'gender': gender.value,
        'report_id': _reportsToId,
        'alternate_report_to': altReport.value,
        'company': _n(company.text),
        'contractor': contractor.value,
        'annual_leave': _n(annualLeave.text),
        'work_type': _workTypeToApi(workType.value),
        'address': _n(address.text),
      };

      final detailBody = <String, dynamic>{
        'user_id': _userId,
        'tax_code': _n(taxCode.text),
        'passport_no': _n(passportNo.text),
        'passport_doi': _n(passportDoi.text),
        'passport_dex': _n(passportDex.text),
        'staff_no': _n(staffNo.text),
        'id_card_no': _n(idCardNo.text),
        'cost_center': _n(costCenter.text),
        'nationality': _n(nationality.text),
        'place_of_birth': _n(placeOfBirth.text),
        'city': _n(city.text),
        'min_hours': _n(minHours.text),
        'max_hours': _n(maxHours.text),
        'date_of_termination': _n(dateTermination.text),
        'reason_of_termination': _n(reasonTermination.text),
        'address': _n(address.text),
        'preferred_days_off': _n(preferredDaysOff.text),
      };

      final r1 = await ProfileService.instance.updateEmpData(profileBody);
      if (!r1.isSuccess) return r1.errorMessage;
      final r2 = await ProfileService.instance.updateEmpDetail(detailBody);
      if (!r2.isSuccess) return r2.errorMessage;
      return null;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      firstName, lastName, fullName, email, dob, doj,
      mobileCompany, mobilePersonal, phoneCompany, emergencyPhone,
      emergencyName, location, company, annualLeave,
      taxCode, passportNo, passportDoi, passportDex, staffNo, idCardNo,
      costCenter, nationality, placeOfBirth, city, minHours, maxHours,
      dateTermination, reasonTermination, address, preferredDaysOff,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
