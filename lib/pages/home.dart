import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cepu_id/utils/UserSimplePreferences.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'login.dart';
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

const Seconds = 30;

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
  String _encryptStr = '';
  double? _progress;
  int _qrTime = 0;
  late Timer _timer;

  @override
  void initState() {
    _displayName = UserSimplePreferences.getDisplayName() ?? '';
    _email = UserSimplePreferences.getEmail() ?? '';
    _photoUrl = UserSimplePreferences.getPhotoUrl() ?? '';
    _googleId = UserSimplePreferences.getGoogleId() ?? '';
    _publicKey = UserSimplePreferences.getPublicKey() ?? '';

    Future setEncryptStrInCache(String fullTime, int qrTime) async {
      _encryptStr = await UserSimplePreferences.setEncryptStr(fullTime) ?? '';
      _qrTime = await UserSimplePreferences.setQrTime(qrTime) ?? 0;
    }

    encryptStr(int qrTime) {
      crypto.RSAKeyParser keyParser = crypto.RSAKeyParser();
      RSAAsymmetricKey publicKeyParser = keyParser.parse(_publicKey);
      final publicKey =
          RSAPublicKey(publicKeyParser.modulus!, publicKeyParser.exponent!);
      final encrypter = crypto.Encrypter(crypto.RSA(publicKey: publicKey));
      final encrypted = encrypter.encrypt(qrTime.toString());

      setEncryptStrInCache('${_googleId}|${encrypted.base64}', qrTime);
      _encryptStr = UserSimplePreferences.getEncryptStr() ?? '';
      _fullTime = _encryptStr;
    }

    getInfoQR() {
      setState(() {
        String currentTime =
            '${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)}';
        var fullTimeInt = int.parse(currentTime);
        assert(fullTimeInt is int);

        int remainTime = fullTimeInt % Seconds;
        int initTime = Seconds - remainTime;
        int qrTime = fullTimeInt - remainTime;
        // print(fullTimeInt - UserSimplePreferences.getQrTime()!);
        if (UserSimplePreferences.getQrTime() != null) {
          if (fullTimeInt - UserSimplePreferences.getQrTime()! > Seconds) {
            encryptStr(qrTime);
            _fullTime = UserSimplePreferences.getEncryptStr() ?? '';
          }
        }
        _qrTime = UserSimplePreferences.getQrTime() ?? 0;
        double timer = (remainTime * (100 / Seconds)) / 100;
        if (UserSimplePreferences.getEncryptStr() != null) {
          if (fullTimeInt % Seconds != 1) {
            _fullTime = UserSimplePreferences.getEncryptStr() ?? '';
            if (timer == 0.0) {
              timer = 1;
            }
            _progress = 1.0 - timer;
          } else {
            // encryptStr(qrTime);
            _progress = 1.0;
          }
        } else {
          encryptStr(qrTime);
        }
      });
    }

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      getInfoQR();
    });
    getInfoQR();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: <Widget>[
          //Buttons in my appBar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //History button
                IconButton(
                  highlightColor: Colors.transparent,
                  tooltip: 'История',
                  padding: EdgeInsets.zero,
                  // iconSize: 30.0,
                  onPressed: () {},
                  icon: Icon(Icons.history_outlined, size: 30),
                ),
                //Logout button
                IconButton(
                  highlightColor: Colors.transparent,
                  tooltip: 'Выйти',
                  padding: EdgeInsets.zero,
                  // iconSize: 30.0,
                  onPressed: () async {
                    _timer.cancel();
                    UserSimplePreferences.clear();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  icon: Icon(Icons.logout, size: 25),
                ),
              ],
            ),
          ),
          //Profile, qr, progress bar widgets in center screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //photoUrl
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(_photoUrl),
                  radius: 45,
                  backgroundColor: Colors.grey[100],
                ),
                SizedBox(height: 15),
                //displayName
                Text(
                  _displayName,
                  style: TextStyle(fontSize: 20, fontFamily: 'Rubik'),
                ),
                SizedBox(height: 5),
                //email
                Text(
                  _email,
                  style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      color: Colors.blueGrey),
                ),
                SizedBox(height: 20),
                //Qrcode
                QrImage(
                  data: '$_fullTime',
                  version: QrVersions.auto,
                  size: 300,
                  gapless: true,
                  // embeddedImage: NetworkImage(_photoUrl),
                  // embeddedImageStyle: QrEmbeddedImageStyle(
                  //   size: Size(288,295),
                  // ),
                ),
                SizedBox(height: 40),
                //progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: SizedBox(
                        width: 100,
                        height: 5,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue[700],
                          value: _progress,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 5,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue[700],
                        value: _progress,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
