import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

const fiveSec = Duration(seconds: 5);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _full_time = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(fiveSec, (Timer t) {
      print(_full_time);
      setState(() {
        _full_time = DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('CepuID'),
      //   centerTitle: true,
      //   backgroundColor: Colors.black45,
      // ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 100)),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/a/ALm5wu3vRRJp5HEJbkPTVQ9qlS2gnKEtY5XZpILH2uXd6w=s288-p-rw-no'),
                  radius: 45,
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  'Эльмир Абкеримов',
                  style: TextStyle(fontSize: 20, fontFamily: 'Rubik'),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  'abkerimov.e.i20@gmail.com',
                  style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      color: Colors.blueGrey),
                ),
                // Text(
                //   'Количество: $_full_time',
                //   style: TextStyle(
                //       fontFamily: 'Rubik', fontSize: 14, color: Colors.blueGrey),
                // ),
                Padding(padding: EdgeInsets.only(top: 20)),
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
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout_outlined),
        onPressed: () {
          setState(() {
            // _full_time++; print('Count: $_full_time');
          });
        },
      ),
    );
  }
}
