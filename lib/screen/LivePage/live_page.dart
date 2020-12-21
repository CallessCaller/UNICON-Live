import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
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
                      child: CarouselSlider(
                        options: CarouselOptions(
                          enableInfiniteScroll: true,
                          viewportFraction: 0.5,
                          height: 150,
                          aspectRatio: 2,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: false,
                        ),
                        items: hotLive(context, lives, userDB),
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
