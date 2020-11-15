import 'package:flutter/material.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_position_seeking.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:testing_layout/components/constant.dart';

String showTime(int time) {
  var now = DateTime.now();
  var showTime = now.difference(new DateTime.fromMillisecondsSinceEpoch(time));

  if (showTime.inMinutes < 60) {
    return showTime.inMinutes.toString() + '분 전';
  } else if (showTime.inHours < 24) {
    return showTime.inHours.toString() + '시간 전';
  } else {
    var postingTime = DateTime.fromMillisecondsSinceEpoch(time);
    return '${postingTime.year}.${postingTime.month}.${postingTime.day}';
  }
}

Widget musicPlayer(AssetsAudioPlayer assetsAudioPlayer) {
  return assetsAudioPlayer.builderCurrent(builder: (context, playing) {
    return assetsAudioPlayer.builderLoopMode(
      builder: (context, loopMode) {
        if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
          return SizedBox();
        return PlayerBuilder.isPlaying(
          player: assetsAudioPlayer,
          builder: (context, isPlaying) {
            return assetsAudioPlayer.builderRealtimePlayingInfos(
                builder: (context, infos) {
              //print("infos: $infos");
              if (infos == null || infos.current == null) {
                return SizedBox();
              }
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    color: Colors.black.withOpacity(0.8),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await assetsAudioPlayer.playOrPause();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              infos.current.audio.audio.metas.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: widgetFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        infos.current.audio.audio.metas.image.path != ''
                            ? Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(infos.current.audio
                                            .audio.metas.image.path))),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -3,
                    left: -24,
                    right: -24,
                    child: PositionSeekWidget(
                      currentPosition: infos.currentPosition,
                      duration: infos.duration,
                      seekTo: (to) {
                        assetsAudioPlayer.seek(to);
                      },
                    ),
                  )
                ],
              );
            });
          },
        );
      },
    );
  });
}
