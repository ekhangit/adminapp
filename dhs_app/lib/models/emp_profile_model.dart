/// Parsed employee profile (from /profile/get-emp-data).
class EmpProfileData {
  final int? userId;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String? type;
  final String? workType;
  final String? dateOfBirth;
  final String? dateOfJoin;
  final String? mobCompany;
  final String? mobPersonal;
  final String? phoneCompany;
  final String? emergencyNumber;
  final String? emergencyName;
  final String? airport;
  final String? location;
  final String? department;
  final String? position;
  final String? reportsTo;
  final String? alternateReportTo;
  final String? company;
  final String? contractor;
  final String? annualLeave;
  final String? gender;

  final int? airportId;
  final int? locationId;
  final int? departmentId;
  final int? positionId;
  final int? reportsToId;

  final List<String> locationOptions;
  final List<String> departmentOptions;
  final List<String> positionOptions;
  final List<String> airportOptions;

  // name → id lookups (for the update payload).
  final Map<String, int> locationIdByName;
  final Map<String, int> departmentIdByName;
  final Map<String, int> positionIdByName;
  final Map<String, int> airportIdByName;

  EmpProfileData({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    this.type,
    this.workType,
    this.dateOfBirth,
    this.dateOfJoin,
    this.mobCompany,
    this.mobPersonal,
    this.phoneCompany,
    this.emergencyNumber,
    this.emergencyName,
    this.airport,
    this.location,
    this.department,
    this.position,
    this.reportsTo,
    this.alternateReportTo,
    this.company,
    this.contractor,
    this.annualLeave,
    this.gender,
    this.airportId,
    this.locationId,
    this.departmentId,
    this.positionId,
    this.reportsToId,
    this.locationOptions = const [],
    this.departmentOptions = const [],
    this.positionOptions = const [],
    this.airportOptions = const [],
    this.locationIdByName = const {},
    this.departmentIdByName = const {},
    this.positionIdByName = const {},
    this.airportIdByName = const {},
  });

  factory EmpProfileData.fromJson(Map<String, dynamic> d) {
    String? s(dynamic v) => v?.toString();
    int? i(dynamic v) => v == null ? null : int.tryParse(v.toString());

    // [{id, name}] → name list + name→id map
    Map<String, int> idMapFromList(dynamic list) {
      final m = <String, int>{};
      if (list is List) {
        for (final e in list) {
          if (e is Map && e['name'] != null && e['id'] != null) {
            m[e['name'].toString()] = i(e['id']) ?? 0;
          }
        }
      }
      return m;
    }

    // {id: name} → name→id map
    Map<String, int> idMapFromMap(dynamic map) {
      final m = <String, int>{};
      if (map is Map) {
        map.forEach((k, v) => m[v.toString()] = i(k) ?? 0);
      }
      return m;
    }

    final locMap = idMapFromList(d['locations']);
    final depMap = idMapFromMap(d['departments']);
    final posMap = idMapFromList(d['positions']);
    final airMap = idMapFromList(d['airports']);
    // Airports list is often empty — seed with the current airport.
    if (airMap.isEmpty && d['airport'] != null && d['airport_id'] != null) {
      airMap[d['airport'].toString()] = i(d['airport_id']) ?? 0;
    }

    return EmpProfileData(
      userId: i(d['user_id']),
      firstName: d['first_name']?.toString() ?? '',
      lastName: d['last_name']?.toString() ?? '',
      fullName: d['full_name']?.toString() ?? '',
      email: d['email']?.toString() ?? '',
      type: s(d['type']),
      workType: s(d['work_type']),
      dateOfBirth: s(d['date_of_birth']),
      dateOfJoin: s(d['date_of_join']),
      mobCompany: s(d['mob_company']),
      mobPersonal: s(d['mob_personal']),
      phoneCompany: s(d['phone_company']),
      emergencyNumber: s(d['emergency_contact_number']),
      emergencyName: s(d['emergency_conntact_name']),
      airport: s(d['airport']),
      location: s(d['location']),
      department: s(d['department']),
      position: s(d['position']),
      reportsTo: s(d['reports_to']),
      alternateReportTo: s(d['alternate_report_to']),
      company: s(d['company']),
      contractor: s(d['contractor']),
      annualLeave: s(d['annual_leave']),
      gender: s(d['gender']),
      airportId: i(d['airport_id']),
      locationId: i(d['location_id']),
      departmentId: i(d['department_id']),
      positionId: i(d['position_id']),
      reportsToId: i(d['reports_to_id']),
      locationOptions: locMap.keys.toList(),
      departmentOptions: depMap.keys.toList(),
      positionOptions: posMap.keys.toList(),
      airportOptions: airMap.keys.toList(),
      locationIdByName: locMap,
      departmentIdByName: depMap,
      positionIdByName: posMap,
      airportIdByName: airMap,
    );
  }
}

/// Parsed employee detail (from /profile/get-emp-detail).
class EmpDetailData {
  final String? taxCode;
  final String? passportNo;
  final String? passportDoi;
  final String? passportDex;
  final String? staffNo;
  final String? idCardNo;
  final String? costCenter;
  final String? nationality;
  final String? placeOfBirth;
  final String? city;
  final String? minHours;
  final String? maxHours;
  final String? dateOfTermination;
  final String? reasonOfTermination;
  final String? address;
  final String? preferredDaysOff;

  EmpDetailData({
    this.taxCode,
    this.passportNo,
    this.passportDoi,
    this.passportDex,
    this.staffNo,
    this.idCardNo,
    this.costCenter,
    this.nationality,
    this.placeOfBirth,
    this.city,
    this.minHours,
    this.maxHours,
    this.dateOfTermination,
    this.reasonOfTermination,
    this.address,
    this.preferredDaysOff,
  });

  factory EmpDetailData.fromJson(Map<String, dynamic> d) {
    String? s(dynamic v) => v?.toString();
    return EmpDetailData(
      taxCode: s(d['tax_code']),
      passportNo: s(d['passport_no']),
      passportDoi: s(d['passport_doi']),
      passportDex: s(d['passport_dex']),
      staffNo: s(d['staff_no']),
      idCardNo: s(d['id_card_no']),
      costCenter: s(d['cost_center']),
      nationality: s(d['nationality']),
      placeOfBirth: s(d['place_of_birth']),
      city: s(d['city']),
      minHours: s(d['min_hours']),
      maxHours: s(d['max_hours']),
      dateOfTermination: s(d['date_of_termination']),
      reasonOfTermination: s(d['reason_of_termination']),
      address: s(d['address']),
      preferredDaysOff: s(d['preferred_days_off']),
    );
  }
}
