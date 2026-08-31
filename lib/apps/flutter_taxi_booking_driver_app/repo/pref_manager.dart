import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  static const String KEY_IS_LOGIN = "is_login";
  static const String KEY_DEFAULT_LAN = "default_lan";
  static const String KEY_DEFAULT_LAN_CODE = "default_lan_code";
  static const String KEY_ONCE_PROMPT_TO_ADD_LOCATION =
      "once_prompt_to_add_location";
  static const String KEY_IS_LOCATION_SEL_FINISH = "is_location_sel_finish";

  static PrefManager? _instance;
  static SharedPreferences? _appPref;

  PrefManager._();

  static Future<PrefManager> getInstance() async {
    _instance ??= PrefManager._();
    _appPref ??= await SharedPreferences.getInstance();

    return _instance!;
  }

  bool get isLogin {
    return _appPref!.getBool(KEY_IS_LOGIN) ?? false;
  }

  set isLogin(bool value) {
    _appPref!.setBool(KEY_IS_LOGIN, value);
  }

  String get defaultLan {
    return _appPref!.getString(KEY_DEFAULT_LAN) ?? "English";
  }

  set defaultLan(String value) {
    _appPref!.setString(KEY_DEFAULT_LAN, value);
  }

  String get defaultLanCode {
    return _appPref!.getString(KEY_DEFAULT_LAN_CODE) ?? "en";
  }

  set defaultLanCode(String value) {
    _appPref!.setString(KEY_DEFAULT_LAN_CODE, value);
  }

  bool get oncePromptAddLoc {
    return _appPref!.getBool(KEY_ONCE_PROMPT_TO_ADD_LOCATION) ?? false;
  }

  set oncePromptAddLoc(bool value) {
    _appPref!.setBool(KEY_ONCE_PROMPT_TO_ADD_LOCATION, value);
  }

  bool get isLocationSelFinish {
    return _appPref!.getBool(KEY_IS_LOCATION_SEL_FINISH) ?? false;
  }

  set isLocationSelFinish(bool value) {
    _appPref!.setBool(KEY_IS_LOCATION_SEL_FINISH, value);
  }
}
