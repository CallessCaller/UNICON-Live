import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/chatting.dart';
import 'package:video_player/video_player.dart';

class WebStreaming extends StatefulWidget {
  final Artist artist;
  final double width;
  WebStreaming({this.artist, this.width});
  @override
  _WebStreamingState createState() => _WebStreamingState();
}

class _WebStreamingState extends State<WebStreaming> {
  VideoPlayerController _controller;
  String _url;
  Image image;
  bool _liveReady = false;

  @override
  void initState() {
    super.initState();
    _url = widget.artist.id == 'artist1'
        ? 'https://5b44cf20b0388.streamlock.net:8443/live/ngrp:live_all/playlist.m3u8'
        : 'http://ynw.fastedge.net:1935/ynw/' +
            widget.artist.id +
            '/playlist.m3u8';
    _controller = VideoPlayerController.network(_url)
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _liveReady = true;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  // void takeSnapshot() async {
  //   Uint8List bytes = await VideoThumbnail.thumbnailData(
  //     video: _url, // Path of that video
  //     imageFormat: ImageFormat.PNG,
  //     quality: 100,
  //     timeMs: _controller.value.position.inMilliseconds,
  //   );
  //   image = Image.memory(bytes); // Here's your frame
  // }

  @override
  Widget build(BuildContext context) {
    if (_liveReady == true && _controller.value.initialized == false) {
      Navigator.of(context).pop();
    }

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          alignment: widget.width == MediaQuery.of(context).size.width
              ? Alignment.center
              : Alignment.centerLeft,
          child: _controller.value.initialized
              ? AnimatedContainer(
                  height: chatFocusNode.hasFocus
                      ? _width * 0.5 / _controller.value.aspectRatio
                      : (widget.width == MediaQuery.of(context).size.width
                              ? widget.width - 50
                              : widget.width) /
                          _controller.value.aspectRatio,
                  width: chatFocusNode.hasFocus
                      ? _width * 0.5
                      : widget.width == MediaQuery.of(context).size.width
                          ? widget.width - 50
                          : widget.width,
                  duration: Duration(milliseconds: 100),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(
                      _controller,
                    ),
                  ),
                )
              // AspectRatio(
              //     aspectRatio: _controller.value.aspectRatio,
              //     child: VideoPlayer(
              //       _controller,
              //     ),
              //   )
              : _liveReady
                  ? Container(
                      height: _height,
                      width: _width,
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          '라이브가 종료되었습니다.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: textFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: _height,
                      width: _width,
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          '라이브가 곧 시작됩니다.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: textFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
    );
  }
}
