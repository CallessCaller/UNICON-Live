import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_feed_box.dart';
import 'package:testing_layout/screen/FeedPage/components/feed_functions.dart';

class MyFeedPage extends StatefulWidget {
  final UserDB userDB;
  final String id;
  MyFeedPage({
    Key key,
    this.userDB,
    this.id,
  }) : super(key: key);

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Feed')
          .where('id', isEqualTo: widget.id)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    final myFeeds = snapshot.map((e) => Feed.fromSnapshot(e)).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: myFeedBoxes(myFeeds, widget.userDB),
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
              child: musicPlayer(_assetsAudioPlayer),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  List<Widget> myFeedBoxes(List<Feed> feeds, UserDB userDB) {
    List<Widget> results = [];
    for (var i = 0; i < feeds.length; i++) {
      results.add(FeedBox(
        feed: feeds[i],
        userDB: userDB,
      ));
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
