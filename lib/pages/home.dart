import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cepu_id/utils/UserSimplePreferences.dart';
import 'package:requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'login.dart';
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:pointycastle/asymmetric/api.dart';


const Seconds = Duration(seconds: 10);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _fullTime = '';
  String _displayName = '';
  String _email = '';
  String _photoUrl = '';
  String _googleId = '';
  String _publicKey = '';
  late Timer _timer;

  @override
  void initState() {
    _displayName = UserSimplePreferences.getDisplayName() ?? '';
    _email = UserSimplePreferences.getEmail() ?? '';
    _photoUrl = UserSimplePreferences.getPhotoUrl() ?? '';
    _googleId = UserSimplePreferences.getGoogleId() ?? '';
    _publicKey = UserSimplePreferences.getPublicKey() ?? '';
    getQrInfo() {
      setState(() {
        crypto.RSAKeyParser keyParser = crypto.RSAKeyParser();
        RSAAsymmetricKey publicKeyParser = keyParser.parse(_publicKey);
        final publicKey =
        RSAPublicKey(publicKeyParser.modulus!, publicKeyParser.exponent!);
        final encrypter = crypto.Encrypter(crypto.RSA(publicKey: publicKey));
        _fullTime = '${DateTime.now().millisecondsSinceEpoch}';
        final encrypted = encrypter.encrypt(_fullTime);
        _fullTime = '${_googleId}|${encrypted.base64}';
        print(_fullTime);
      });
    };
    _timer = Timer.periodic(Seconds, (Timer timer) {
      getQrInfo();
    });
    getQrInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;

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
                    Padding(padding: EdgeInsets.only(top: 60)),
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
                    backgroundImage: CachedNetworkImageProvider(_photoUrl),
                    radius: 45,
                    // child: Image.network('https://i.ytimg.com/vi/-Fz-Z_P8Z0Q/maxresdefault.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Text(
                    _displayName,
                    style: TextStyle(fontSize: 20, fontFamily: 'Rubik'),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    _email,
                    style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        color: Colors.blueGrey),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  QrImage(
                    data: '$_fullTime',
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


}
