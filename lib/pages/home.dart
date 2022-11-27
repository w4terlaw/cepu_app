import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cepu_id/utils/UserSimplePreferences.dart';
import 'package:requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'login.dart';

const Seconds = Duration(seconds: 5);

class Home extends StatefulWidget {
  // final GoogleSignInAccount user;
  //
  // const Home({Key? key, required this.user}) : super(key: key);

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _full_time = DateTime.now().millisecondsSinceEpoch;
  String displayName = '';
  String email = '';
  String photoUrl = '';
  late Timer _timer;

  @override
  void initState() {
    displayName = UserSimplePreferences.getDisplayName() ?? '';
    email = UserSimplePreferences.getEmail() ?? '';
    photoUrl = UserSimplePreferences.getPhotoUrl() ?? '';
    super.initState();
    _timer = Timer.periodic(Seconds, (timer) {
      print(_full_time);
      setState(() {
        _full_time = DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // if (displayName != ''){
    //   Timer.periodic(fiveSec, (Timer t) {
    //       print(_full_time);
    //       setState(() {
    //         _full_time = DateTime.now().millisecondsSinceEpoch;
    //       });
    //     });
    // }
    // var value = '{' + data.toString() + '}';
    // Map valueMap = json.decode(value);
    // Map<String, dynamic> datas = json.decode(data.toString());
    // List<dynamic> objectUrls = datas['objectUrls'];
    // print(data[0]["signedUrl"]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20.0),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 40)),
                    IconButton(
                        // iconSize: 30.0,
                        onPressed: () async {
                          _timer.cancel();
                          UserSimplePreferences.clear();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        icon: Icon(Icons.logout)),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //     padding: EdgeInsets.only(top: screenSize.height * 0.15)),
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(photoUrl),
                    radius: 45,
                    // child: Image.network('https://i.ytimg.com/vi/-Fz-Z_P8Z0Q/maxresdefault.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Text(
                    displayName,
                    style: TextStyle(fontSize: 20, fontFamily: 'Rubik'),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    email,
                    style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        color: Colors.blueGrey),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  QrImage(
                    data: '$_full_time',
                    version: QrVersions.auto,
                    size: 300,
                    gapless: true,
                    // embeddedImage: NetworkImage('https://yt3.ggpht.com/ytc/AKedOLRCvhZh9AZaL_nN3a78Wqw7WUT9y_WYq2CN5fYV=s900-c-k-c0x00ffffff-no-rj'),
                    // embeddedImageStyle: QrEmbeddedImageStyle(
                    //   size: Size(52, 52),
                    // ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 100)),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }

  void req() async {
    var id = 2;
    var url = 'https://raw.githubusercontent.com/todo/api/v1.0/tasks/$id';

    // Await the http get response, then decode the json-formatted response.
    var response = await Requests.get(url);
    // print(response.content());
    if (response.statusCode == 200) {
      var jsonResponse = response.json();
      // var jsonresp = jsonResponse;
      print(jsonResponse["user_name"]);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
