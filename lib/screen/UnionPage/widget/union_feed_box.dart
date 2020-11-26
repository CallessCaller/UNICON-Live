import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/providers/stream_of_user.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_detail.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';

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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StreamProvider.value(
            value: StreamOfuser().getUser(widget.userDB.id),
            child: FeedDetail(
              feed: widget.feed,
              userDB: widget.userDB,
            ),
          ),
        ));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), color: Colors.black),
            width: (MediaQuery.of(context).size.width - 60 - 7) / 2,
            height: (MediaQuery.of(context).size.width - 60 - 7) / 2,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _showTime(widget.feed.time),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  widget.feed.content.trim(),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1.8,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          widget.feed.image != null
              ? CachedNetworkImage(
                  imageUrl: widget.feed.image,
                  imageBuilder: (context, imageProvider) => Container(
                    width: (MediaQuery.of(context).size.width - 60 - 7) / 2,
                    height: (MediaQuery.of(context).size.width - 60 - 7) / 2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          widget.feed.progressive != null
              ? Container(
                  width: (MediaQuery.of(context).size.width - 60 - 7) / 2,
                  height: (MediaQuery.of(context).size.width - 60 - 7) / 2,
                  alignment: Alignment.topRight,
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FeedDetail(
                              feed: widget.feed,
                              userDB: widget.userDB,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  String _showTime(int time) {
    var postingTime = DateTime.fromMillisecondsSinceEpoch(time);
    return '${postingTime.year}.${postingTime.month}.${postingTime.day}';
  }
}
