import 'package:flutter/material.dart';
import 'package:cepu_id/pages/home.dart';
import 'package:cepu_id/pages/login.dart';
import 'package:cepu_id/utils/UserSimplePreferences.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  if (UserSimplePreferences.getDisplayName() != null) {
    runApp(MaterialApp(
      home: Home(),
    ),);
  }
  else{
    runApp(MaterialApp(
      home: Login(),
    ),);
  }
}

// Future main2() async {
//   await UserSimplePreferences.init();
// }

