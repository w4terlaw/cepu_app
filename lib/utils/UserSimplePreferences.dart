import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _displayName = 'displayName';
  static const _email = 'email';
  static const _photoUrl = 'photoUrl';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future clear() => _preferences!.clear();

  //Display name
  static Future setDisplayName(String displayName) async {
    await _preferences?.setString(_displayName, displayName);
  }

  static String? getDisplayName() => _preferences?.getString(_displayName);

  //Email
  static Future setEmail(String email) async {
    await _preferences?.setString(_email, email);
  }

  static String? getEmail() => _preferences?.getString(_email);

  //PhotoUrl
  static Future setPhotoUrl(String photoUrl) async {
    await _preferences?.setString(_photoUrl, photoUrl);
  }

  static String? getPhotoUrl() => _preferences?.getString(_photoUrl);
}
