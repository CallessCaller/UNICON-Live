import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
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
                  icon: Icon(Icons.explore),
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
                  icon: Icon(Icons.edit),
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
                  icon: Icon(Icons.sticky_note_2),
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
              ]
            : [
                IconButton(
                  icon: Icon(Icons.explore),
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
