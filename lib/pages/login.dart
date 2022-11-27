import 'dart:async';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:cepu_id/api/GoogleSignInApi.dart';
import 'package:cepu_id/pages/home.dart';
import 'package:cepu_id/utils/UserSimplePreferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // static const email = 'email';
  // GoogleSignInAccount? _currentUser;
  Map<String, dynamic> data = {};

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
                    'CEPU/qr',
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
    try {
      final user = await GoogleSignInApi.login();

      if (user == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Не удалось выполнить вход, попробуйте позже')));
      } else {
        data = {
          'displayName': user.displayName,
          'email': user.email,
          'id': user.id,
          'photoUrl': user.photoUrl
        };
        req(data['displayName']);
        // print(user.email);
        await UserSimplePreferences.setDisplayName(data['displayName']);
        await UserSimplePreferences.setPhotoUrl(data['photoUrl']);
        await UserSimplePreferences.setEmail(data['email']);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }
      await GoogleSignInApi.logout();
    } catch (err) {
      print('Error --------: $err');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Не удалось выполнить вход')));
    }

  }

  void req(link) async {
    var url = 'http://localhost:5000/todo/api/v1.0/tasks/$link';

    // Await the http get response, then decode the json-formatted response.
    var response = await Requests.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = response.json();
      // var jsonresp = jsonResponse;
      print(jsonResponse["user_name"]);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
