import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/UnionPage/widget/union_feed_box.dart';

class UnionPageBody extends StatefulWidget {
  final UserDB userDB;
  final Artist artist;
  UnionPageBody({this.userDB, this.artist});
  @override
  _UnionPageBodyState createState() => _UnionPageBodyState();
}

class _UnionPageBodyState extends State<UnionPageBody> {
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Feed')
          .where('id', isEqualTo: widget.artist.id)
          .orderBy('time', descending: true)
          .limit(60)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<Feed> feeds = snapshot.map((e) => Feed.fromSnapshot(e)).toList();
    return feeds.length == 0
        ? Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Text(
              '피드가 없습니다.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.bold),
            ))
        : Container(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 7.0,
              runSpacing: 7.0,
              children: feeds
                  .map((e) => UnionFeedBox(feed: e, userDB: widget.userDB))
                  .toList(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
