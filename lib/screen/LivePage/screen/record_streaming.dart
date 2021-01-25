import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/records.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/widget/record_box.dart';
import 'package:testing_layout/screen/UnionPage/widget/liked_musician_box.dart';
import 'package:video_player/video_player.dart';

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
  Future<void> futureController;
  bool _visible = false;
  bool liked = false;

  @override
  void initState() {
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
      //userDB.liked_video.add(widget.record.name);

      await FirebaseFirestore.instance
          .collection('Records')
          .doc(record.name)
          .update({'liked': record.liked});
      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(userDB.id)
      //     .update({'liked_video': userDB.liked_video});

      // if (_live) {
      //   await _firebaseMessaging.subscribeToTopic(artist.id + 'live');
      // }
      // if (_feed) {
      //   await _firebaseMessaging.subscribeToTopic(artist.id + 'Feed');
      // }
    }

    // Unliked
    else {
      record.liked.remove(userDB.id);
      // userDB.liked_video.remove(record.name);

      await FirebaseFirestore.instance
          .collection('Records')
          .doc(record.name)
          .update({'liked': record.liked});
      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(userDB.id)
      //     .update({'liked_video': userDB.liked_video});

      // await _firebaseMessaging.unsubscribeFromTopic(artist.id + 'live');

      // await _firebaseMessaging.unsubscribeFromTopic(artist.id + 'Feed');
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
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
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
                                                  });
                                                },
                                                icon: Icon(
                                                  UniIcon.like_ena,
                                                  size: 30,
                                                  color: appKeyColor,
                                                ),
                                              ),
                                              Text(
                                                '${widget.record.liked.length}',
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
                                                  });
                                                },
                                                icon: Icon(
                                                  UniIcon.like_dis,
                                                  size: 30,
                                                ),
                                              ),
                                              Text(
                                                '${widget.record.liked.length}',
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
                                      child: LikedMusicianBox(
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
        result.add(RecordBox(record: records[i]));
        result.add(Divider(
          height: 20,
          color: Colors.transparent,
        ));
      }
    }
    return result;
  }
}
