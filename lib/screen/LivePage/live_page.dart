import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/screen/notification.dart';
import 'package:testing_layout/screen/LivePage/widget/live_box.dart';
import 'package:testing_layout/screen/LivePage/widget/live_header.dart';
import 'package:testing_layout/screen/LivePage/widget/recommendation_sliders.dart';

class LivePage extends StatefulWidget {
  LivePage({
    Key key,
  }) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  void initState() {
    super.initState();
  }

  // void makeToken(UserDB userDB) async {
  //   String currentToken = await FirebaseMessaging().getToken();
  //   if (userDB.token == null || userDB.token != currentToken) {
  //     userDB.token = currentToken;
  //     userDB.reference.update({'token': currentToken});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final lives = Provider.of<List<Lives>>(context);
    final userDB = Provider.of<UserDB>(context);
    // makeToken(userDB);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: false,
        title: Container(
          height: 40,
          child: Image.asset(
            'assets/slogan_02.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        actions: [
          IconButton(
              splashRadius: Material.defaultSplashRadius - 7,
              icon: Icon(MdiIcons.bellOutline),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationPage()));
              }),
          IconButton(
              splashRadius: Material.defaultSplashRadius - 7,
              icon: Icon(
                MdiIcons.tea,
              ),
              onPressed: () async {
                FTPConnect ftpConnect = FTPConnect('ynw.fastedge.net',
                    user: 'ynw', pass: r"sjh12dnjf30dlf!@#$5");
                await ftpConnect.connect();

                var fileList = await ftpConnect.listDirectoryContentOnlyNames();
                fileList.removeWhere((element) => element.contains('test'));
                print(fileList.toString());
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
        },
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  LiveHeader(userDB: userDB),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        'HOT LIVE',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: HotLives(
                          userDB: userDB,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.transparent,
                    height: 10.0,
                  ),
                  Text(
                    'ALL LIVE',
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ] +
                currentLives(userDB, lives),
          ),
        ]),
      ),
    );
  }

  List<Widget> currentLives(UserDB userDB, List<Lives> lives) {
    List<Widget> result = [];
    for (int i = 0; i < lives.length; i++) {
      result.add(LiveBox(live: lives[i]));
      result.add(Divider());
    }
    if (result.length == 0) {
      result.add(Center(
        child: Text('현재 라이브가 없습니다.'),
      ));
    }
    return result;
  }
}
