import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_comment_box.dart';

class CommentBoxes extends StatefulWidget {
  final Feed feed;
  final UserDB userDB;
  CommentBoxes({this.feed, this.userDB});
  @override
  _CommentBoxesState createState() => _CommentBoxesState();
}

class _CommentBoxesState extends State<CommentBoxes> {
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Feed')
            .doc(widget.feed.feedID)
            .collection('comments')
            .orderBy('time', descending: true)
            .limit(100)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return _buildBody(context, snapshot.data);
        });
  }

  Widget _buildBody(BuildContext context, QuerySnapshot snapshot) {
    List<CommentBox> results = [];
    var userDB = Provider.of<UserDB>(context);
    for (var i = 0; i < snapshot.docs.length; i++) {
      if (userDB.dislikePeople != null) {
        if (userDB.dislikePeople.contains(snapshot.docs[i].data()['id'])) {
          continue;
        }
      }
      if (userDB.dislikeComment != null) {
        if (userDB.dislikeComment.contains(snapshot.docs[i].id)) {
          continue;
        }
      }

      results.add(CommentBox(
        comment: snapshot.docs[i],
        userId: userDB.id,
        ownerId: widget.feed.id,
      ));
    }
    // List<CommentBox> results = snapshot.docs
    //     .map((e) => CommentBox(
    //           comment: e,
    //           userId: widget.userDB.id,
    //           ownerId: widget.feed.id,
    //         ))
    //     .toList();

    return Column(
      children: results,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
