import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_total.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_write_page.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_my_feed_page.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_feed_box.dart';
import 'feed_functions.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_position_seeking.dart';

class FeedPage extends StatefulWidget {
  FeedPage({
    Key key,
  }) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDB = Provider.of<UserDB>(context);
    var feeds = Provider.of<List<Feed>>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  userDB.isArtist
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                    new BorderRadius.circular(widgetRadius),
                              ),
                              height: 30,
                              minWidth:
                                  (MediaQuery.of(context).size.width - 60) / 3,
                              color: appKeyColor,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FeedTotal(
                                      userDB: userDB,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '전체보기',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widgetFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                    new BorderRadius.circular(widgetRadius),
                              ),
                              color: appKeyColor,
                              height: 30,
                              minWidth:
                                  (MediaQuery.of(context).size.width - 60) / 3,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FeedWritePage(
                                      userDB: userDB,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '새글쓰기',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widgetFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                    new BorderRadius.circular(widgetRadius),
                              ),
                              height: 30,
                              minWidth:
                                  (MediaQuery.of(context).size.width - 60) / 3,
                              color: appKeyColor,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MyFeedPage(
                                      userDB: userDB,
                                      id: userDB.id,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '내글보기',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widgetFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      : FlatButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.circular(widgetRadius),
                          ),
                          height: 30,
                          minWidth: (MediaQuery.of(context).size.width - 40),
                          color: appKeyColor,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FeedTotal(
                                  userDB: userDB,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '전체 보기',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: widgetFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  Column(
                    children: feedBoxes(feeds, userDB),
                  ),
                  Container(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 40,
                child: musicPlayer(_assetsAudioPlayer)),
          ),
        ],
      ),
    );
  }

  List<Widget> feedBoxes(List<Feed> feeds, UserDB userDB) {
    List<Widget> results = [];
    for (var i = 0; i < feeds.length; i++) {
      if (userDB.follow.contains(feeds[i].id)) {
        results.add(FeedBox(
          feed: feeds[i],
          userDB: userDB,
        ));
      }
    }
    if (results.length == 0) {
      results.add(Container(
        alignment: Alignment.center,
        height: 300,
        child: Text(
          '글이 없습니다.',
          style: TextStyle(fontSize: textFontSize, fontWeight: FontWeight.w600),
        ),
      ));
    }
    return results;
  }
}
