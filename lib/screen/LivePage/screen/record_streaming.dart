import 'dart:io';

import 'package:flutter/material.dart';
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
  bool showIcon = false;
  @override
  void initState() {
    controller = VideoPlayerController.network(
        'http://ynw.fastedge.net:1935/vod/_definst_/${widget.record.name}/playlist.m3u8');
    futureController = controller.initialize();
    controller.setLooping(true);
    controller.setVolume(50.0);
    super.initState();
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
            SizedBox(height: Platform.isIOS ? 40 : 0),
            FutureBuilder(
                future: futureController,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (controller.value.isPlaying) {
                          } else {}
                        });
                      },
                      child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller)),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ]),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3 / 2,
            left: MediaQuery.of(context).size.width * 0.5 - 44,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: FlatButton(
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
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
