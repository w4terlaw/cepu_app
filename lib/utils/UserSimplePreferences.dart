import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _displayName = 'displayName';
  static const _email = 'email';
  static const _photoUrl = 'photoUrl';
  static const _googleId = 'google_id';
  static const _publicKey = 'public_key';
  static const _encryptStr = 'encryptStr';
  static const _qrTime = 'qrTime';

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

  //Google_id
  static Future setGoogleId(String google_id) async {
    await _preferences?.setString(_googleId, google_id);
  }

  static String? getGoogleId() => _preferences?.getString(_googleId);

  //Public_key
  static Future setPublicKey(String publicKey) async {
    await _preferences?.setString(_publicKey, publicKey);
  }

  static String? getPublicKey() => _preferences?.getString(_publicKey);

  //encryptSTRING
  static Future setEncryptStr(String encryptStr) async {
    await _preferences?.setString(_encryptStr, encryptStr);
  }

  static String? getEncryptStr() => _preferences?.getString(_encryptStr);

  static Future setQrTime(int qrTime) async {
    await _preferences?.setInt(_qrTime, qrTime);
  }

  static int? getQrTime() => _preferences?.getInt(_qrTime);
}
