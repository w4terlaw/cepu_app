import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cepu_id/api/GoogleSignInApi.dart';
import 'package:cepu_id/pages/home.dart';
import 'package:cepu_id/utils/UserSimplePreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // static const email = 'email';
  // GoogleSignInAccount? _currentUser;
  // Map<String, dynamic> data = {};

  // int _full_time = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    // _googleSignIn.onCurrentUserChanged.listen((account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    // });
    // _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Padding(padding: EdgeInsets.only(top: 300)),
          //     Text('CEPU/qr',style: TextStyle(
          //         fontFamily: 'Rubik',
          //         fontWeight: FontWeight.bold,
          //         fontSize: 40,
          //         color: Colors.grey),)
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CEPUqr',
                    style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.grey),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(234, 232, 232, 1.0)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        side: MaterialStateProperty.all(BorderSide(
                            color: Color.fromRGBO(234, 232, 232, 1.0),
                            width: 1.0,
                            style: BorderStyle.solid))),
                    onPressed: signIn,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/google_logo.png"),
                            radius: 15,
                          ),
                          // Image(
                          //   image: AssetImage("assets/images/google_logo.png"),
                          //   height: 40.0,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Войти через Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Rubik',
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 140)),
            ],
          ),
        ]),
      ),
    );
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Не удалось выполнить вход')));
    } else {
      await GoogleSignInApi.logout();

      final uri = Uri.https('flask-pymongo-server.vercel.app', '/user/add');

      final msg = jsonEncode({
        "displayName": user.displayName!,
        "email": user.email,
        "google_id": user.id,
        "photoUrl": user.photoUrl!
      });

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: msg,
      );
      // print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        await UserSimplePreferences.setDisplayName(jsonResponse['displayName']);
        await UserSimplePreferences.setPhotoUrl(jsonResponse['photoUrl']);
        await UserSimplePreferences.setEmail(jsonResponse['email']);
        await UserSimplePreferences.setGoogleId(jsonResponse['google_id']);
        await UserSimplePreferences.setPublicKey(jsonResponse['public_key']);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }
}
