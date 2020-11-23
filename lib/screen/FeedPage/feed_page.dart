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
import 'components/feed_functions.dart';

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

    if (userDB == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            '유니온 피드',
            style: headline2,
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '로그인 후 유니온들의 소식을 둘러보세요!',
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  color: appKeyColor,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  },
                  child: Text('로그인'),
                ),
              ],
            )),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '유니온 피드',
          style: headline2,
        ),
        actions: userDB.isArtist
            ? [
                IconButton(
                  icon: Icon(
                    Icons.explore_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FeedTotal(
                          userDB: userDB,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FeedWritePage(
                          userDB: userDB,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 30,
                  ),
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
                ),
              ]
            : [
                IconButton(
                  icon: Icon(
                    Icons.explore_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FeedTotal(
                          userDB: userDB,
                        ),
                      ),
                    );
                  },
                )
              ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
        results.add(Divider(
          height: 5,
          thickness: 5,
          color: appBarColor,
        ));
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
