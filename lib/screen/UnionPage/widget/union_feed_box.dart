import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_detail.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_edit.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_content_expand.dart';
import 'package:testing_layout/screen/UnionPage/union_page.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:http/http.dart' as http;
import 'package:testing_layout/screen/FeedPage/components/feed_functions.dart';

class UnionFeedBox extends StatefulWidget {
  final Feed feed;
  final UserDB userDB;
  UnionFeedBox({this.feed, this.userDB});
  @override
  _UnionFeedBoxState createState() => _UnionFeedBoxState();
}

class _UnionFeedBoxState extends State<UnionFeedBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.feed.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data);
      },
    );
  }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FeedDetail(
              feed: widget.feed,
              userDB: widget.userDB,
            ),
          ),
        );
      },
      child: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), color: Colors.white),
              width: (MediaQuery.of(context).size.width - 60) / 2,
              height: (MediaQuery.of(context).size.width - 60) / 2,
              alignment: Alignment.center,
              child: Text(
                widget.feed.content.trim(),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600),
              ),
            ),
            widget.feed.image != null
                ? Hero(
                    tag: widget.feed.feedID,
                    child: CachedNetworkImage(
                      imageUrl: widget.feed.image,
                      imageBuilder: (context, imageProvider) => Container(
                        width: (MediaQuery.of(context).size.width - 60) / 2,
                        height: (MediaQuery.of(context).size.width - 60) / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            widget.feed.progressive != null
                ? Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: (MediaQuery.of(context).size.width - 60) / 2,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff8e00c9),
                            Color(0xff160176),
                          ],
                        ),
                      ),
                      child: IconButton(
                        iconSize: 30,
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
