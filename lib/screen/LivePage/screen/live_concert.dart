import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/chatting.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/webConstant.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/web_streaming.dart';

bool artistTap = false;

class LiveConcert extends StatefulWidget {
  final Artist artist;
  final Lives live;
  final UserDB userDB;
  LiveConcert({
    this.live,
    this.artist,
    this.userDB,
  });

  @override
  _LiveConcertState createState() => _LiveConcertState();
}

class _LiveConcertState extends State<LiveConcert> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  Stream<DocumentSnapshot> documentStream;
  List<dynamic> viewers = [];

  StreamSubscription<DocumentSnapshot> stream;

  SharedPreferences _preferences;
  bool _live = true;
  bool _feed = true;

  void _loadFirst() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      // SharedPreferences에 counter로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _live = (_preferences.getBool('_live') ?? true);
      _feed = (_preferences.getBool('_feed') ?? true);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    hideChat = true;
    _loadFirst();
    cleanDislikeChat();
    documentStream = FirebaseFirestore.instance
        .collection('LiveTmp')
        .doc(widget.live.id)
        .snapshots(includeMetadataChanges: true);

    stream = documentStream.listen((event) {
      setState(() {
        viewers = event.data()['viewers'];
      });
    });

    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
      ]);
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // hide status bar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stream.cancel();
    // chatFocusNode.dispose();

    removeFromViewers();

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void removeFromViewers() async {
    DocumentSnapshot artistDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .get();
    if (artistDoc.data()['live_now'] == true) {
      DocumentSnapshot liveDoc = await FirebaseFirestore.instance
          .collection('LiveTmp')
          .doc(widget.artist.id)
          .get();
      List<dynamic> viewers = liveDoc.data()['viewers'];
      viewers.remove(widget.userDB.id);

      await FirebaseFirestore.instance
          .collection('LiveTmp')
          .doc(widget.artist.id)
          .update({'viewers': viewers});
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      // This code is listening for inactive, paused, detached cases
      // For example when the user presses the home button the state becomes inactive
      // When the user forces to terminate the process it is assumed to become detached
      // So in these cases the List viewers must pop the user
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await detachedCallBack();
        break;
      // If the user accesses the app again when 'inactive',
      // the state changes to 'resumed'
      // So in this case the List viewers must add the user
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }

  detachedCallBack() async {
    DocumentSnapshot artistDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .get();
    if (artistDoc.data()['live_now'] == true) {
      DocumentSnapshot liveDoc = await FirebaseFirestore.instance
          .collection('LiveTmp')
          .doc(widget.artist.id)
          .get();
      List<dynamic> viewers = liveDoc.data()['viewers'];
      viewers.remove(widget.userDB.id);

      await FirebaseFirestore.instance
          .collection('LiveTmp')
          .doc(widget.artist.id)
          .update({'viewers': viewers});
    }
  }

  resumeCallBack() async {
    DocumentSnapshot artistDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .get();
    if (artistDoc.data()['live_now'] == true) {
      DocumentSnapshot liveDoc = await FirebaseFirestore.instance
          .collection('LiveTmp')
          .doc(widget.artist.id)
          .get();
      List<dynamic> viewers = liveDoc.data()['viewers'];
      viewers.remove(widget.userDB.id);

      await FirebaseFirestore.instance
          .collection('LiveTmp')
          .doc(widget.artist.id)
          .update({'viewers': viewers});
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(
            child: new Text(
              '라이브가 곧 종료됩니다.',
              style: TextStyle(
                  fontSize: subtitleFontSize, fontWeight: FontWeight.bold),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "나가기",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.artist.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data);
      },
    );
  }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    Artist _artist = Artist.fromSnapshot(snapshot);
    if (_artist.liveNow == false) {
      Future.delayed(Duration.zero, () async {
        _showExitDialog();
      });
    }
    double maxwidth = MediaQuery.of(context).size.width;
    double maxheight = MediaQuery.of(context).size.height;

    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(children: [
        InkWell(
          onTap: () {
            setState(() {
              if (chatFocusNode.hasFocus) {
                chatFocusNode.unfocus();
              } else {
                artistTap = !artistTap;
              }
            });
          },
          child: WebStreaming(
            artist: _artist,
            width: hideChat ? maxwidth : maxwidth * 0.7,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ChatWidget(
            keyboardHeight: keyboardHeight,
            live: widget.live,
            artist: _artist,
            userDB: widget.userDB,
            width: hideChat ? maxwidth - maxwidth : maxwidth - maxwidth * 0.7,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 50,
                width: hideChat
                    ? maxwidth
                    : chatFocusNode.hasFocus
                        ? maxwidth * 0.5
                        : maxwidth * 0.7,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: appKeyColor,
                      radius: 8,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        viewers.length.toString() + '  명 시청중',
                        style: TextStyle(
                            fontSize: widgetFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          hideChat
                              ? Icons.chat_bubble_outline
                              : Icons.chat_bubble,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            hideChat = !hideChat;
                            chatFocusNode.unfocus();
                          });
                        }),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: artistTap ? 100 : 0,
                width: hideChat
                    ? maxwidth
                    : chatFocusNode.hasFocus
                        ? maxwidth * 0.5
                        : maxwidth * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                  ),
                ),
                child: Row(
                  children: [
                    VerticalDivider(
                      width: 20,
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(_artist.profile),
                    ),
                    VerticalDivider(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _artist.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: subtitleFontSize),
                          ),
                          Text(
                            '라이브 방송중',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: subtitleFontSize - 2),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      height: 50,
                      color: appKeyColor,
                      onPressed: () {
                        _onLikePressed(widget.userDB);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            widget.userDB.follow.contains(_artist.id)
                                ? MdiIcons.heart
                                : MdiIcons.heartOutline,
                            size: 25,
                          ),
                          Text(
                            ' Follow',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: subtitleFontSize),
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  void cleanDislikeChat() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userDB.id)
        .update({'dislikeChat': []});
  }

  void _onLikePressed(UserDB userDB) async {
    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    DocumentSnapshot artistDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .get();
    List<dynamic> myPeople = artistDoc.data()['my_people'];
    setState(() {
      // Add data to CandidatesDB
      if (!myPeople.contains(widget.userDB.id)) {
        myPeople.add(userDB.id);
        userDB.follow.add(widget.artist.id);
        if (_live) {
          _firebaseMessaging.subscribeToTopic(widget.artist.id + 'live');
        }
        if (_feed) {
          _firebaseMessaging.subscribeToTopic(widget.artist.id + 'Feed');
        }
      }

      // Unliked
      else {
        myPeople.remove(userDB.id);
        // Delete data from UsersDB

        userDB.follow.remove(widget.artist.id);
        if (_live) {
          _firebaseMessaging.unsubscribeFromTopic(widget.artist.id + 'live');
        }
        if (_feed) {
          _firebaseMessaging.unsubscribeFromTopic(widget.artist.id + 'Feed');
        }
      }
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .update({'my_people': myPeople});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userDB.id)
        .update({'follow': userDB.follow});
  }
}
