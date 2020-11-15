import 'package:flutter/material.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_my_feed_page.dart';

class UnionFeedTotal extends StatelessWidget {
  final UserDB userDB;
  final String id;
  UnionFeedTotal({this.userDB, this.id});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        UniIcon.feed_disabled,
        size: 35,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyFeedPage(
              userDB: userDB,
              id: id,
            ),
          ),
        );
      },
    );
  }
}
