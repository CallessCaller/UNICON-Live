import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_layout/model/records.dart';
import 'package:video_player/video_player.dart';

class RecordStreaming extends StatefulWidget {
  final Records record;

  const RecordStreaming({Key key, this.record}) : super(key: key);
  @override
  _RecordStreamingState createState() => _RecordStreamingState();
}

class _RecordStreamingState extends State<RecordStreaming> {
  VideoPlayerController controller;
  Future<void> futureController;
  bool _visible = false;
  @override
  void initState() {
    controller = VideoPlayerController.network(
        'http://ynw.fastedge.net:1935/vod/_definst_/${widget.record.name}/playlist.m3u8');
    futureController = controller.initialize();
    controller.setLooping(true);
    controller.setVolume(50.0);
    controller.play();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Column(children: [
            SizedBox(
                height: Platform.isIOS
                    ? MediaQuery.of(context).orientation == Orientation.portrait
                        ? 40
                        : 0
                    : 0),
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
                          ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller))
                          : Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width:
                                    MediaQuery.of(context).size.height * 16 / 9,
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
              top: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.2981 -
                      (Platform.isAndroid ? 40 : 0)
                  : MediaQuery.of(context).size.height * 0.915,
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width * 0.7,
              left: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0
                  : MediaQuery.of(context).size.width * 0.13,
              child: !_visible
                  ? VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                    )
                  : SizedBox()),
          Positioned(
            top: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.3 / 2
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      onPressed: () async {
                        await controller.seekTo(
                            await controller.position - Duration(seconds: 10));
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
                            await controller.position + Duration(seconds: 10));
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
            bottom: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.69 -
                    (Platform.isAndroid ? 40 : 0)
                : 0,
            right: MediaQuery.of(context).orientation == Orientation.portrait
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
    );
  }
}
