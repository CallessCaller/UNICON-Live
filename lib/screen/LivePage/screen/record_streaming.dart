import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:overlay_dialog/overlay_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/records.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/widget/record_box.dart';
import 'package:testing_layout/screen/LivePage/widget/record_box2.dart';
import 'package:testing_layout/screen/UnionPage/widget/liked_musician_box.dart';
import 'package:video_player/video_player.dart';

import '../../UnionPage/union_page.dart';

class RecordStreaming extends StatefulWidget {
  final Records record;
  final Artist artist;
  final UserDB userDB;

  const RecordStreaming({Key key, this.record, this.artist, this.userDB})
      : super(key: key);
  @override
  _RecordStreamingState createState() => _RecordStreamingState();
}

class _RecordStreamingState extends State<RecordStreaming> {
  VideoPlayerController controller;
  int total_liked;
  Future<void> futureController;
  bool _visible = false;
  bool liked = false;

  TextEditingController _controller;
  @override
  void initState() {
    total_liked = widget.record.liked.length;
    controller = VideoPlayerController.network(
        'http://ynw.fastedge.net:1935/vod/_definst_/${widget.record.name}/playlist.m3u8');
    futureController = controller.initialize();
    controller.setLooping(false);
    controller.setVolume(50.0);
    controller.play();

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
  }

  void _onLikePressed() async {
    var artistSnap = await FirebaseFirestore.instance
        .collection('Records')
        .doc(widget.record.name)
        .get();
    Records record = Records.fromSnapshot(artistSnap);

    var userSnap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userDB.id)
        .get();
    UserDB userDB = UserDB.fromSnapshot(userSnap);
    // Add data to CandidatesDB
    if (!record.liked.contains(widget.userDB.id)) {
      record.liked.add(userDB.id);
      if (userDB.liked_video == null) {
        await widget.userDB.reference.set({'liked_video': []});
      }
      userDB.liked_video.add(record.name);
      await FirebaseFirestore.instance
          .collection('Records')
          .doc(record.name)
          .update({'liked': record.liked});
      await widget.userDB.reference.update({'liked_video': userDB.liked_video});
      widget.record.liked.length;
    }

    // Unliked
    else {
      record.liked.remove(userDB.id);
      userDB.liked_video.remove(record.name);

      await FirebaseFirestore.instance
          .collection('Records')
          .doc(record.name)
          .update({'liked': record.liked});
      await widget.userDB.reference.update({'liked_video': userDB.liked_video});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat serverFormat = DateFormat('yyyy-MM-dd');
    final records = Provider.of<List<Records>>(context);
    // final musicians = Artist.fromSnapshot();
    return SafeArea(
      top: MediaQuery.of(context).orientation == Orientation.portrait
          ? true
          : false,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: !_visible
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  IconButton(
                      icon: Icon(Icons.warning_amber_rounded),
                      onPressed: () {
                        report_record_Alert(
                            context, widget.userDB, _controller);
                      }),
                ],
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios)))
            : PreferredSize(child: Container(), preferredSize: Size(0, 0)),
        body: Column(
          children: [
            Stack(
              children: [
                Column(children: [
                  FutureBuilder(
                      future: futureController,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                            child: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width *
                                        9 /
                                        16,
                                    child: VideoPlayer(controller))
                                : Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              16 /
                                              9,
                                      child: VideoPlayer(controller),
                                    ),
                                  ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ]),
                !_visible
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _visible = !_visible;
                          });
                        },
                        child: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.width * 9 / 16,
                                decoration:
                                    BoxDecoration(color: Colors.black26),
                              )
                            : Center(
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.height *
                                      16 /
                                      9,
                                  decoration:
                                      BoxDecoration(color: Colors.black26),
                                ),
                              ),
                      )
                    : SizedBox(),
                Positioned(
                    top: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.width * 9 / 16 - 4
                        : MediaQuery.of(context).size.height * 0.915,
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.7,
                    left: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 0
                        : MediaQuery.of(context).size.width * 0.13,
                    child: !_visible
                        ? VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            padding: EdgeInsets.zero,
                          )
                        : SizedBox()),
                Positioned(
                  top:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width * 9 / 16 / 2 - 22
                          : MediaQuery.of(context).size.height * 0.5 - 22,
                  // left: MediaQuery.of(context).size.width * 0.5 - 88 / 2 * 3,
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width,
                    height: _visible ? 0.0 : 44.0,
                    duration: Duration(milliseconds: 200),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: _visible ? 0.0 : 1.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            onPressed: () async {
                              await controller.seekTo(
                                  await controller.position -
                                      Duration(seconds: 10));
                            },
                            child: Image.asset(
                              'assets/10secbackwards.png',
                              color: Colors.white60,
                              scale: 20,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                if (controller.value.isPlaying) {
                                  controller.pause();
                                } else {
                                  controller.play();
                                }
                              });
                            },
                            child: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FlatButton(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            onPressed: () async {
                              await controller.seekTo(
                                  await controller.position +
                                      Duration(seconds: 10));
                            },
                            child: Image.asset(
                              'assets/10secforwards.png',
                              color: Colors.white60,
                              scale: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width * 9 / 16 - 55
                          : MediaQuery.of(context).size.height * 0.85,
                  right:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 0
                          : MediaQuery.of(context).size.width * 0.1,
                  child: !_visible
                      ? IconButton(
                          icon: Icon(MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? Icons.fullscreen
                              : Icons.fullscreen_exit),
                          onPressed: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.landscape) {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                              ]);
                            } else if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              if (Platform.isAndroid) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeLeft,
                                ]);
                              } else {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                ]);
                              }
                            }
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeRight,
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.portraitUp,
                            ]);
                          })
                      : SizedBox(),
                ),
              ],
            ),

            //

            //

            //
            MediaQuery.of(context).orientation == Orientation.portrait
                ? Column(
                    children: [
                      Container(
                        // height: 165,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.artist.name}님의 지난 공연',
                                        style: title3,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            (widget.record.total.length
                                                    .toString() +
                                                ' View' +
                                                (widget.record.total.length > 1
                                                    ? 's'
                                                    : '')),
                                            style: body3,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            (serverFormat.format(widget
                                                    .record.date
                                                    .toDate()))
                                                .toString(),
                                            style: body3,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  widget.record.liked
                                              .contains(widget.userDB.id) ==
                                          !liked
                                      ? Container(
                                          child: Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _onLikePressed();

                                                    liked = !liked;
                                                    --total_liked;
                                                  });
                                                },
                                                icon: Icon(
                                                  UniIcon.like_ena,
                                                  size: 30,
                                                  color: appKeyColor,
                                                ),
                                              ),
                                              Text(
                                                total_liked.toString(),
                                                style: body3,
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(
                                          child: Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _onLikePressed();

                                                    liked = !liked;
                                                    ++total_liked;
                                                  });
                                                },
                                                icon: Icon(
                                                  UniIcon.like_dis,
                                                  size: 30,
                                                ),
                                              ),
                                              Text(
                                                total_liked.toString(),
                                                style: body3,
                                              )
                                            ],
                                          ),
                                        ),
                                  // IconButton(
                                  //     icon: widget.record.liked
                                  //             .contains(widget.userDB.id)
                                  //         ? Icon(UniIcon.like_ena)
                                  //         : Icon(
                                  //             UniIcon.like_dis,
                                  //             size: 30,
                                  //           ),
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         _onLikePressed();
                                  //       });
                                  //     }),
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      child: LikedMusicianBox2(
                                          userDB: widget.userDB,
                                          artist: widget.artist),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              'Others',
                              style: title2,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: MediaQuery.of(context).size.height -
                                  ((MediaQuery.of(context).size.width *
                                          9 /
                                          16) +
                                      270),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Column(
                                      children: [
                                            Container(height: 0, width: 10),
                                            SizedBox(
                                              height: 0,
                                            ),
                                          ] +
                                          currentRecords(records)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  List<Widget> currentRecords(List<Records> records) {
    List<Widget> result = [];
    for (int i = records.length - 1; i > -1; i--) {
      if (records[i].name != widget.record.name) {
        result.add(RecordBox2(record: records[i]));
        result.add(Divider(
          height: 20,
          color: Colors.transparent,
        ));
      }
    }
    return result;
  }
}

class LikedMusicianBox2 extends StatefulWidget {
  final Artist artist;
  final UserDB userDB;
  LikedMusicianBox2({this.artist, this.userDB});

  @override
  _LikedMusicianBox2State createState() => _LikedMusicianBox2State();
}

class _LikedMusicianBox2State extends State<LikedMusicianBox2> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _loadFirst();
  }

  SharedPreferences _preferences;
  bool _live = true;
  bool _feed = true;
  bool followed = true;

  void _loadFirst() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      // SharedPreferences에 counter로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _live = (_preferences.getBool('_live') ?? true);
      _feed = (_preferences.getBool('_feed') ?? true);
    });
  }

  void _onLikePressed() async {
    var artistSnap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .get();
    Artist artist = Artist.fromSnapshot(artistSnap);

    var userSnap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userDB.id)
        .get();
    UserDB userDB = UserDB.fromSnapshot(userSnap);
    // Add data to CandidatesDB
    if (!artist.myPeople.contains(widget.userDB.id)) {
      artist.myPeople.add(userDB.id);
      userDB.follow.add(widget.artist.id);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(artist.id)
          .update({'my_people': artist.myPeople});
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDB.id)
          .update({'follow': userDB.follow});

      if (_live) {
        await _firebaseMessaging.subscribeToTopic(artist.id + 'live');
      }
      if (_feed) {
        await _firebaseMessaging.subscribeToTopic(artist.id + 'Feed');
      }
    }

    // Unliked
    else {
      artist.myPeople.remove(userDB.id);
      userDB.follow.remove(artist.id);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(artist.id)
          .update({'my_people': artist.myPeople});
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDB.id)
          .update({'follow': userDB.follow});

      await _firebaseMessaging.unsubscribeFromTopic(artist.id + 'live');

      await _firebaseMessaging.unsubscribeFromTopic(artist.id + 'Feed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UnionInfoPage(
              artist: widget.artist,
              userDB: widget.userDB,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(widgetDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widgetRadius),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: outlineColor,
                    width: .5,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.artist.resizedProfile != null &&
                            widget.artist.resizedProfile != ''
                        ? widget.artist.resizedProfile
                        : widget.artist.profile),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(widgetRadius),
                ),
              ),
              SizedBox(
                width: widgetDefaultPadding,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.artist.liveNow != null && widget.artist.liveNow
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.artist.name,
                                softWrap: true,
                                style: subtitle2,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.all(widgetDefaultPadding * 0.5),
                                child: Center(
                                  child: Text(
                                    'ON-AIR',
                                    style: TextStyle(
                                      color: appKeyColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Text(
                            widget.artist.name,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                    SizedBox(
                      height: widgetDefaultPadding * 0.5,
                    ),
                    Text(
                      widget.artist.genre != null
                          ? widget.artist.genre.join(' / ')
                          : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              widget.artist.myPeople.contains(widget.userDB.id) == followed
                  ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        setState(() {
                          _onLikePressed();
                          followed = !followed;
                        });
                      },
                      child: Text(
                        '팔로잉',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: outlineColor,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: outlineColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: 50,
                      height: 30,
                    )
                  : FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        setState(() {
                          _onLikePressed();
                          followed = !followed;
                        });
                      },
                      child: Text(
                        '팔로우',
                        style: body3,
                      ),
                      color: appKeyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: 50,
                      height: 30,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

void report_record_Alert(BuildContext context, UserDB userDB,
    TextEditingController _controller) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dialogRadius),
          ),
          backgroundColor: dialogColor1,
          title: Center(
            child: Text(
              "신고",
              style: title1,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "부적절한 영상인가요?",
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      color: dialogColor3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widgetRadius),
                      ),
                      child: Text(
                        '아니요',
                        style: TextStyle(
                          color: dialogColor4,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FlatButton(
                      color: appKeyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widgetRadius),
                      ),
                      child: Text(
                        '네',
                        style: subtitle3,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                                child: AlertDialog(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(dialogRadius),
                                    ),
                                    backgroundColor: dialogColor1,
                                    title: Center(
                                      child: Text(
                                        "신고",
                                        style: title1,
                                      ),
                                    ),
                                    content: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              8 /
                                              25,
                                      width: MediaQuery.of(context).size.width *
                                          1 /
                                          2,
                                      child: Column(children: [
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: _controller,
                                          maxLines: 7,
                                          autocorrect: false,
                                          cursorHeight: 14,
                                          keyboardType: TextInputType.multiline,
                                          style: body2,
                                          decoration: InputDecoration(
                                            //labelText:'신고 이유',
                                            // labelStyle: TextStyle(
                                            //       color: Colors.white,
                                            //       fontSize: 14,
                                            //       fontWeight: FontWeight.w600,),
                                            hintText: '이유를 적어주세요.',
                                            // hasFloatingPlaceholder: false,
                                            // counterText: 'gdgdgdg',
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      widgetRadius)),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      widgetRadius)),
                                              borderSide: BorderSide(
                                                color: appKeyColor,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(children: [
                                          Expanded(
                                            child: FlatButton(
                                              color: dialogColor3,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widgetRadius),
                                              ),
                                              child: Text(
                                                '취소',
                                                style: TextStyle(
                                                  color: dialogColor4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                              child: FlatButton(
                                            color: appKeyColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widgetRadius),
                                            ),
                                            child: Text(
                                              '네',
                                              style: subtitle3,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ))
                                        ])
                                      ]),
                                    )),
                              );
                            });

                        //});
                        // if (userDB
                        //         .dislikeComment ==
                        //     null) {
                        //   await userDB.reference
                        //       .update({
                        //     'dislikeComment': []
                        //   });
                        // }

                        // int report =
                        //     widget.comment.data()[
                        //             'report'] +
                        //         1;

                        // await widget
                        //     .comment.reference
                        //     .update({
                        //   'report': (report)
                        // });

                        // userDB.dislikeComment.add(
                        //     widget.comment
                        //         .reference.id);

                        // await userDB.reference
                        //     .update({
                        //   'dislikeComment': userDB
                        //       .dislikeComment
                        // });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      });
}
