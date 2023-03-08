import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/UserSimplePreferences.dart';

Future userFromApi(user) async {
  final uri = Uri.http('192.168.0.240:5000', '/user/add');

  final msg = jsonEncode({
    "display_name": user.displayName,
    "email": user.email,
    "google_id": user.id,
    "photo_url": user.photoUrl,
  });

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // 'authorization': 'Basic '+base64Encode(utf8.encode('miguel:python')),
  };
  http.Response response = await http.post(
    uri,
    headers: headers,
    body: msg,
  );

  // print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    await UserSimplePreferences.setUserMap(jsonResponse);
    await UserSimplePreferences.setIsLoggedIn(true);
    print('Request data: $jsonResponse.');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
