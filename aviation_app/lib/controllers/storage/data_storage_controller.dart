import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class DataStorageController extends GetxController {
  static DataStorageController get to => Get.find();
  late SharedPreferences _prefs;
  var session = Rxn<Map>();
  var currentSession = Rxn<UserModel>();
  var profileCached = false.obs;
  var header = Rxn<Map>();

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
        picture: session.value!["picture"],
      );

  Future<void> saveToken(String token) async {
    _prefs.setString("fcm_token", token);
    await AuthService.instance.setFCMToken(token);
  }


  Future<String> getFCMToken() async {
    return _prefs.getString("fcm_token") ?? "";
  }

  Future<String> getRefCode() async {
    return _prefs.getString("refCode") ?? "";
  }

  Future<String> fetchAuthToken() async {
    await initPrefs();
    return _prefs.getString("auth") ?? "";
  }

  Future<void> initiateSession() async {
    if ((_prefs.getInt("id") ?? 0) != 0) {
      // log("initiateSession");

      currentSession.value = UserModel(
        id: _prefs.getInt("id") ?? 0,
        name: _prefs.getString("name")!,
        email: _prefs.getString("email")!,
        picture: _prefs.getString("picture") ?? "",
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
    // log("[currentSession] SESSION VALUE ${session.value}");
    // log("[currentSession] Header Value ${header.value}");
  }

  Future<Map<String, dynamic>> getSessionMap() async {
    return {
      'id': _prefs.getInt("id"),
      'name': _prefs.getString("name"),
      'picture': _prefs.getString("picture") ?? "",
    };
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {
      // 'authid': apiKey,
      'authuid': _prefs.getString("auth") ?? "",
    };
    return headers;
  }


  Future<void> createAccount(Map<String, dynamic> response) async {
    print("[DataStorageController] createAccount: $response");

    _prefs.setInt('id', response['id']);
    _prefs.setString('name', response['name'] ?? "");
    _prefs.setString('picture', response['picture'] ?? "");
    _prefs.setString('email', response['email']);
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
