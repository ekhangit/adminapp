import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/emp_profile_model.dart';
import '../../models/user_model.dart';
import '../../services/profile_service.dart';

class DataStorageController extends GetxController {
  static DataStorageController get to => Get.find();
  late SharedPreferences _prefs;
  var session = Rxn<Map>();
  var currentSession = Rxn<UserModel>();
  var profileCached = false.obs;
  var header = Rxn<Map>();

  /// Current employee profile (fetched from get-emp-data after login).
  final Rxn<EmpProfileData> empProfile = Rxn<EmpProfileData>();

  Future<void> loadEmpProfile() async {
    if (session.value == null) return;
    final res = await ProfileService.instance.getEmpData(user.id);
    if (res.isSuccess && res.data != null) {
      empProfile.value = res.data;
    }
  }

  @override
  void onInit() async {
    await initPrefs();
    super.onInit();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await initiateSession();
  }

  UserModel get user => UserModel(
    id: session.value!["id"],
    name: session.value!["name"],
    email: session.value!["email"],
    profilePhotoPath: session.value!["picture"],
  );

  Future<String> fetchAuthToken() async {
    await initPrefs();
    return _prefs.getString("auth") ?? "";
  }

  Future<void> initiateSession() async {
    if ((_prefs.getInt("id") ?? 0) != 0) {
      currentSession.value = UserModel(
        id: _prefs.getInt("id") ?? 0,
        name: _prefs.getString("name")!,
        email: _prefs.getString("email")!,
        profilePhotoPath: _prefs.getString("picture") ?? "",
      );

      session.value = {
        "id": _prefs.getInt("id"),
        "name": _prefs.getString("name")!,
        "email": _prefs.getString("email")!,
        "picture": _prefs.getString("picture") ?? "",
      };
    } else {
      session.value = null;
      currentSession.value = null;
    }

    header.value = await getHeaders();

    // log("[currentSession] CURRENT SESSION VALUE ${currentSession.value}");
    log("[currentSession] SESSION VALUE ${session.value}");
    log("[currentSession] Header Value ${header.value}");
  }

  Future<Map<String, dynamic>> getSessionMap() async {
    return {
      'id': _prefs.getInt("id"),
      'name': _prefs.getString("name"),
      'picture': _prefs.getString("picture") ?? "",
    };
  }

  Future<Map<String, String>> getHeaders() async {
    return {'Authorization': 'Bearer ${_prefs.getString("auth") ?? ""}'};
  }

  Future<void> createAccount(Map<String, dynamic> response) async {
    print("[DataStorageController] createAccount: $response");

    final user = response['user'];
    final apiToken = response['api_token'];

    if (user != null) {
      _prefs.setInt('id', user['id']);
      _prefs.setString('name', user['name'] ?? "");
      _prefs.setString('email', user['email'] ?? "");
      _prefs.setString('picture', user['profile_photo_path'] ?? "");
    }

    if (apiToken != null) {
      _prefs.setString('auth', apiToken);
    }

    await initiateSession();
  }

  Future<void> updateSession(Map<String, dynamic> value) async {
    value.forEach((key, val) {
      if (val != null) {
        if (val is String) {
          _prefs.setString(key, val);
        } else if (val is int) {
          _prefs.setInt(key, val);
        } else if (val is bool) {
          _prefs.setBool(key, val);
        }
      }
    });
    await initiateSession();
  }

  Future<void> clearSession() async {
    await _prefs.clear();
    session.value = null;
    currentSession.value = null;
    await initiateSession();
  }
}
