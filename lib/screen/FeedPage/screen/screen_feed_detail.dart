import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_edit.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_comment.dart';
import 'package:testing_layout/screen/UnionPage/union_page.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:http/http.dart' as http;
import 'package:testing_layout/screen/FeedPage/components/feed_functions.dart';

class FeedDetail extends StatefulWidget {
  final Feed feed;
  final UserDB userDB;
  FeedDetail({this.feed, this.userDB});
  @override
  _FeedDetailState createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  String _clientId = '95f22ed54a5c297b1c41f72d713623ef';

  final TextEditingController _controller = TextEditingController(text: '');
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _focusNode.dispose();
  }

  void _onLikePressed() async {
    setState(() {
      // Add data to CandidatesDB
      if (!widget.feed.like.contains(widget.userDB.id)) {
        widget.feed.like.add(widget.userDB.id);
      }

      // Unliked
      else {
        // Delete data from CandidatesDB
        widget.feed.like.remove(widget.userDB.id);
        // Delete data from UsersDB

      }
    });
    await widget.feed.reference.update({'like': widget.feed.like});
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          '댓글',
          style: headline2,
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  var artistSnapshot = await FirebaseFirestore
                                      .instance
                                      .collection('Users')
                                      .doc(widget.feed.id)
                                      .get();
                                  Artist artist =
                                      Artist.fromSnapshot(artistSnapshot);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UnionInfoPage(
                                        artist: artist,
                                        userDB: widget.userDB,
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(snapshot.data()['profile']),
                                  radius: 17,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                snapshot.data()['name'],
                                style: body2,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  showTime(widget.feed.time),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: outlineColor,
                                  ),
                                ),
                              ),
                              widget.feed.id == widget.userDB.id
                                  ? PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(11)),
                                      color: Colors.white,
                                      icon: Icon(
                                        Icons.more_horiz,
                                        size: 20,
                                      ),
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text(
                                            '수정',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Text(
                                            '삭제',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                      onSelected: (value) {
                                        if (value == 1) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FeedEditPage(
                                                          feed: widget.feed)));
                                        } else if (value == 2) {
                                          showAlertDialog(context);
                                        }
                                      },
                                    )
                                  : InkWell(
                                      onTap: _onLikePressed,
                                      child: widget.feed.like
                                              .contains(widget.userDB.id)
                                          ? Icon(
                                              UniIcon.like_ena,
                                              color: appKeyColor,
                                              size: 30,
                                            )
                                          : Icon(
                                              UniIcon.like_dis,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                    ),
                            ],
                          ),
                        ),
                        widget.feed.progressive != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
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
                                        icon: Icon(
                                          Icons.play_arrow_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          try {
                                            var response = await http.get(
                                                '${widget.feed.progressive}?client_id=' +
                                                    _clientId);
                                            String streamURL = json
                                                .decode(response.body)['url'];

                                            await _assetsAudioPlayer.open(
                                              Audio.network(
                                                streamURL,
                                                metas: Metas(
                                                    title: widget.feed.title,
                                                    image: MetasImage.network(
                                                        widget.feed.artwork ??
                                                            '')),
                                              ),
                                              autoStart: true,
                                              showNotification: false,
                                              playInBackground:
                                                  PlayInBackground.enabled,
                                              audioFocusStrategy:
                                                  AudioFocusStrategy.request(
                                                      resumeAfterInterruption:
                                                          true,
                                                      resumeOthersPlayersAfterDone:
                                                          true),
                                              headPhoneStrategy:
                                                  HeadPhoneStrategy
                                                      .pauseOnUnplug,
                                            );
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        widget.feed.title,
                                        softWrap: true,
                                        style: body3,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.feed.content.trim(),
                              maxLines: 1000,
                              overflow: TextOverflow.ellipsis,
                              style: body3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.feed.image != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: CachedNetworkImage(
                            imageUrl: widget.feed.image,
                            imageBuilder: (context, imageProvider) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageProvider,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Divider(
                    color: outlineColor,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CommentBoxes(
                      feed: widget.feed,
                      userId: widget.userDB.id,
                    ),
                  ),
                  SizedBox(
                    height: 120,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 70,
              child: musicPlayer(_assetsAudioPlayer),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: appBarColor,
                width: width,
                height: 70,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 51,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20),
                          ),
                          border: Border.all(
                            color: outlineColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(widget.userDB.profile),
                              radius: 17,
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                              thickness: 1,
                              width: 6,
                            ),
                            Expanded(
                              child: TextField(
                                autocorrect: false,
                                focusNode: _focusNode,
                                controller: _controller,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  hintText: '댓글 달기',
                                  hintStyle: body3,
                                ),
                                style: body3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () async {
                        if (_controller.text != '') {
                          await widget.feed.reference
                              .collection('comments')
                              .add({
                            'id': widget.userDB.id,
                            'content': _controller.text,
                            'time': DateTime.now().millisecondsSinceEpoch
                          });
                        }
                        _controller.clear();
                        _focusNode.unfocus();
                      },
                      child: Container(
                        height: 51,
                        width: 67,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20),
                          ),
                          border: Border.all(
                            color: outlineColor,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '게시',
                            style: body3,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              //side: BorderSide(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(11)),
          backgroundColor: Colors.black,
          content: Text(
            "정말 삭제하시겠습니까?",
            style: TextStyle(fontSize: textFontSize),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '삭제',
                style: TextStyle(fontSize: textFontSize),
              ),
              onPressed: () async {
                await widget.userDB.reference
                    .collection('my_post')
                    .doc(widget.feed.feedID)
                    .delete();
                await widget.feed.reference.delete();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '취소',
                style: TextStyle(fontSize: textFontSize),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
