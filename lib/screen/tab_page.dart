import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/providers/stream_of_user.dart';
import 'package:testing_layout/screen/AccountPage/account_page.dart';
import 'package:testing_layout/screen/FeedPage/feed_page.dart';
import 'package:testing_layout/screen/LivePage/live_page.dart';
import 'package:testing_layout/screen/SearchPage/search_page.dart';

import '../model/users.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  Animation animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  List<Widget> _pages = [
    LivePage(),
    SearchPage(),
    FeedPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print('token:' + token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //TODO: 알람 처리하는 로직
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserDB>.value(
      value: StreamOfuser().getUser(_auth.currentUser.uid),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.dark,
          elevation: 0,
          toolbarHeight: 0,
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            onTap: _onItemTapped,
            selectedItemColor: appKeyColor,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            elevation: 0,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widgetFontSize,
            ),
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0
                      ? UniIcon.home_enabled
                      : UniIcon.home_disabled,
                ),
                label: 'Live',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1
                      ? UniIcon.search_enabled
                      : UniIcon.search_disabled,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2 ? Icons.article : Icons.article_outlined,
                ),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                    height: 25,
                    width: 25,
                    child: _selectedIndex == 3
                        ? BottomProfile(color: appKeyColor)
                        : BottomProfile(color: Colors.grey)),
                label: 'Account',
              ),
            ],
          ),
        ),
        body: Column(
            children:[ IndexedStack(
              children: _pages,
              index: _selectedIndex,
          ),Container(child: Text('hi'))
          ]
        ),
      ),
    );
  }
}

class BottomProfile extends StatelessWidget {
  final Color color;
  BottomProfile({this.color});

  @override
  Widget build(BuildContext context) {
    UserDB userDB = Provider.of<UserDB>(context);
    if (userDB == null) {
      return Icon(UniIcon.settings);
    } else {
      return CachedNetworkImage(
        imageUrl: userDB.profile,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(UniIcon.settings),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            backgroundImage: imageProvider,
          ),
        ),
      );
    }
  }
}
