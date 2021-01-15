import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/records.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/my_broadcast_screen/broadcast_setting.dart';
import 'package:testing_layout/screen/LivePage/screen/notification.dart';
import 'package:testing_layout/screen/LivePage/widget/live_box.dart';
import 'package:testing_layout/screen/LivePage/widget/live_header.dart';
import 'package:testing_layout/screen/LivePage/widget/recommendation_sliders.dart';
import 'package:testing_layout/screen/LivePage/widget/record_box.dart';

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
    final records = Provider.of<List<Records>>(context);
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
          userDB.isArtist
              ? IconButton(
                  splashRadius: Material.defaultSplashRadius - 7,
                  icon: Icon(MdiIcons.videoCheck),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BroadcastSetting(userDB: userDB),
                      ),
                    );
                  })
              : SizedBox(),
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
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            LiveHeader(userDB: userDB),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HOT LIVE', style: subtitle1),
                  SizedBox(
                    height: 20,
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
            ),
            Divider(
              color: Color(0xff313131),
              height: 50.0,
              thickness: 5.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Container(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('VIDEO', style: subtitle1),
                              FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    '전체보기',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                    ] +
                    [
                      RecordBox(
                        record: records[0],
                      )
                    ],
              ),
            ),
            Divider(
              color: Color(0xff313131),
              height: 50.0,
              thickness: 5.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Text('ALL LIVE', style: subtitle1),
                      SizedBox(
                        height: 20,
                      ),
                    ] +
                    currentLives(userDB, lives),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  List<Widget> currentLives(UserDB userDB, List<Lives> lives) {
    List<Widget> result = [];
    for (int i = 0; i < lives.length; i++) {
      result.add(LiveBox(live: lives[i]));
      result.add(Divider(
        height: 20,
        color: Colors.transparent,
      ));
    }
    if (result.length == 0) {
      result.add(Center(
        child: Text('현재 라이브가 없습니다.'),
      ));
    }
    return result;
  }

  List<Widget> currentRecords() {
    List<Widget> result = [];
    return result;
  }
}
