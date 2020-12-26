import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/providers/stream_of_artist.dart';
import 'package:testing_layout/providers/stream_of_feed.dart';
import 'package:testing_layout/providers/stream_of_live.dart';
import 'package:testing_layout/screen/AppGuide/screen_app_guide.dart';
import 'package:testing_layout/screen/LoginPage/login_page.dart';
import 'package:testing_layout/screen/tab_page.dart';
import 'model/feed.dart';

import 'package:kakao_flutter_sdk/all.dart';

bool _isFirst = true;
bool _needLogin = false;
bool _exist = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  KakaoContext.clientId = "70dfdacac39561e5f245a4bd09ef9509";

  InAppPurchaseConnection.enablePendingPurchases();
  SharedPreferences _preferences = await SharedPreferences.getInstance();

  _isFirst = (_preferences.getBool('first') ?? true);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  if (_auth.currentUser == null) {
    _needLogin = true;
  } else {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) => {_exist = value.exists});
  }

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<QuerySnapshot>.value(
            value: StreamOfArtist().getArtists()),
        StreamProvider<List<Lives>>.value(value: StreamOfLive().getLives()),
        StreamProvider<List<Feed>>.value(value: StreamOfFeed().getFeeds()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.black,
        ),
        title: 'Unicon',
        initialRoute: _isFirst
            ? '/first_installed'
            : _needLogin
                ? '/login'
                : _exist
                    ? '/inapp'
                    : '/login',
        // initialRoute: '/first_installed',
        routes: {
          '/first_installed': (context) => AppGuideScreen(),
          '/login': (context) => LoginPage(),
          '/inapp': (context) => TabPage(),
        },
      ),
    );
  }
}
