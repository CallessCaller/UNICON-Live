import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/providers/stream_of_artist.dart';
import 'package:testing_layout/providers/stream_of_feed.dart';
import 'package:testing_layout/providers/stream_of_live.dart';
import 'package:testing_layout/screen/AppGuide/widget/widget_walkthroughslide.dart';
import 'package:testing_layout/screen/LoginPage/login_page.dart';
import 'package:testing_layout/screen/tab_page.dart';
import 'model/feed.dart';

import 'package:kakao_flutter_sdk/all.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  KakaoContext.clientId = "70dfdacac39561e5f245a4bd09ef9509";

  InAppPurchaseConnection.enablePendingPurchases();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _needLogin = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null) {
      setState(() {
        _needLogin = true;
      });
    }
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
        // TODO : check if app is first installed
        initialRoute: _needLogin ? '/login' : '/inapp',
        routes: {
          '/first-installed': (context) => WalkthroughSlide(),
          '/login': (context) => LoginPage(),
          '/inapp': (context) => TabPage(),
        },
      ),
    );
  }
}
