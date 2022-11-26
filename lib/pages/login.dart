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
    // GoogleSignInAccount? user = _currentUser;
    // if (user != null) {
    //   print(user);
    //   data = {
    //     'displayName': user.displayName,
    //     'email': user.email,
    //     'id': user.id,
    //     'photoUrl': user.photoUrl
    //   };
    // }
    // if (data.isNotEmpty) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     // appBar: AppBar(
    //     //   title: Text('CepuID'),
    //     //   centerTitle: true,
    //     //   backgroundColor: Colors.black45,
    //     // ),
    //     body: SafeArea(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Column(
    //             children: [
    //               Padding(padding: EdgeInsets.only(top: 100)),
    //               CircleAvatar(
    //                 backgroundImage: NetworkImage(data['photoUrl']),
    //                 radius: 45,
    //               ),
    //               Padding(padding: EdgeInsets.only(top: 15)),
    //               Text(
    //                 data['displayName'],
    //                 style: TextStyle(fontSize: 20, fontFamily: 'Rubik'),
    //               ),
    //               Padding(padding: EdgeInsets.only(top: 5)),
    //               Text(
    //                 data['email'],
    //                 style: TextStyle(
    //                     fontFamily: 'Rubik',
    //                     fontSize: 14,
    //                     color: Colors.blueGrey),
    //               ),
    //               // Text(
    //               //   'Количество: $_full_time',
    //               //   style: TextStyle(
    //               //       fontFamily: 'Rubik', fontSize: 14, color: Colors.blueGrey),
    //               // ),
    //               Padding(padding: EdgeInsets.only(top: 20)),
    //               QrImage(
    //                 data: '$_full_time',
    //                 version: QrVersions.auto,
    //                 size: 300,
    //                 gapless: true,
    //                 // embeddedImage: NetworkImage('https://yt3.ggpht.com/ytc/AKedOLRCvhZh9AZaL_nN3a78Wqw7WUT9y_WYq2CN5fYV=s900-c-k-c0x00ffffff-no-rj'),
    //                 // embeddedImageStyle: QrEmbeddedImageStyle(
    //                 //   size: Size(52, 52),
    //                 // ),
    //               ),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //         child: Icon(Icons.logout_outlined),
    //         onPressed: () {
    //           signOut();
    //           data = {};
    //         }
    //         // setState(() {
    //         //   req();
    //         //   // _full_time++; print('Count: $_full_time');
    //         // });
    //         ),
    //   );
    //   // return Padding(
    //   //   padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
    //   //   child: Column(
    //   //     children: [
    //   //       ListTile(
    //   //         leading: GoogleUserCircleAvatar(identity: user),
    //   //         title:  Text(user.displayName ?? '', style: TextStyle(fontSize: 22),),
    //   //         subtitle: Text(user.email, style: TextStyle(fontSize: 22)),
    //   //       ),
    //   //       const SizedBox(height: 20,),
    //   //       const Text(
    //   //         'Signed in successfully',
    //   //         style: TextStyle(fontSize: 20),
    //   //       ),
    //   //       const SizedBox(height: 10,),
    //   //       ElevatedButton(
    //   //           onPressed: signOut,
    //   //           child: const Text('Sign out')
    //   //       ),
    //   //
    //   //       ElevatedButton(
    //   //           onPressed: () { Navigator.pushNamed(context, '/home', arguments: user,);
    //   //             // setState(() {
    //   //             //   req();
    //   //             //   // _full_time++; print('Count: $_full_time');
    //   //             // });
    //   //           },
    //   //           child: const Text('Дать инфу')
    //   //       )
    //   //     ],
    //   //   ),
    //   // );
    // } else {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Войдите в аккаунт',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: signIn,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Войти', style: TextStyle(fontSize: 30)),
              )),
        ],
      ),
    );
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();
    await GoogleSignInApi.logout();
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Не удалось выполнить вход')));
    } else {
      data = {
        'displayName': user.displayName.toString(),
        'email': user.email,
        'id': user.id,
        'photoUrl': user.photoUrl
      };
      // print(user.email);
      await UserSimplePreferences.setDisplayName(data['displayName']);
      await UserSimplePreferences.setPhotoUrl(data['photoUrl']);
      await UserSimplePreferences.setEmail(data['email']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }
  }

  void req() async {
    var id = 2;
    var url = 'http://localhost:5000/todo/api/v1.0/tasks/$id';

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
