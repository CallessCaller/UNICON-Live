import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_detail.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_edit.dart';
import 'package:testing_layout/screen/UnionPage/union_page.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:http/http.dart' as http;
import 'package:testing_layout/screen/FeedPage/components/feed_functions.dart';

class FeedBox extends StatefulWidget {
  final Feed feed;
  final UserDB userDB;
  FeedBox({this.feed, this.userDB});
  @override
  _FeedBoxState createState() => _FeedBoxState();
}

class _FeedBoxState extends State<FeedBox> {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  String _clientId = '95f22ed54a5c297b1c41f72d713623ef';

  final TextEditingController _controller = TextEditingController(text: '');
  final FocusNode _focusNode = FocusNode();

  String firstHalf;
  String secondHalf;

  bool flag = true;

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
    String trimmedContent = widget.feed.content.trim();
    if (trimmedContent.length > 50) {
      firstHalf = trimmedContent.substring(0, 50);
      secondHalf = trimmedContent.substring(50, trimmedContent.length);
    } else {
      firstHalf = trimmedContent;
      secondHalf = "";
    }

    return Card(
      elevation: 0,
      color: Colors.black,
      shadowColor: Colors.black,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 47,
              padding: EdgeInsets.fromLTRB(12, 6, 0, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      var artistSnapshot = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.feed.id)
                          .get();
                      Artist artist = Artist.fromSnapshot(artistSnapshot);
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
                      backgroundImage: NetworkImage(snapshot.data()['profile']),
                      radius: 17,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      snapshot.data()['name'],
                      style: body2,
                    ),
                  ),
                  widget.feed.id == widget.userDB.id
                      ? PopupMenuButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11)),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      FeedEditPage(feed: widget.feed)));
                            } else if (value == 2) {
                              showAlertDialog(context);
                            }
                          },
                        )
                      : FlatButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: true, // user must tap button!

                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      //side: BorderSide(color: Colors.white.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(11)),
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    "부적절한 콘텐츠 인가요?",
                                    style: TextStyle(fontSize: textFontSize),
                                  ),
                                  content: Text(
                                    "이 유니온의 콘텐츠를 더이상 표시하지 않습니다.",
                                    style:
                                        TextStyle(fontSize: textFontSize - 2),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        '예',
                                        style: TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        if (widget.userDB.dislike == null) {
                                          await widget.userDB.reference
                                              .update({'dislike': []});
                                        }
                                        widget.userDB.dislike
                                            .add(widget.feed.id);
                                        if (widget.userDB.follow
                                            .contains(widget.feed.id)) {
                                          widget.userDB.follow
                                              .remove(widget.feed.id);
                                        }

                                        await widget.userDB.reference.update({
                                          'dislike': widget.userDB.dislike,
                                          'follow': widget.userDB.follow
                                        });

                                        var artist = await FirebaseFirestore
                                            .instance
                                            .collection('Users')
                                            .doc(widget.feed.id)
                                            .get()
                                            .then((value) =>
                                                Artist.fromSnapshot(value));
                                        if (artist.myPeople
                                            .contains(widget.userDB.id)) {
                                          artist.myPeople
                                              .remove(widget.userDB.id);
                                        }
                                        await artist.reference.update(
                                            {'my_people': artist.myPeople});

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        '흐음..',
                                        style:
                                            TextStyle(fontSize: textFontSize),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            '신고 및 숨기기',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                ],
              ),
            ),
            Column(
              children: [
                widget.feed.progressive != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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
                                iconSize: 30,
                                icon: Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  try {
                                    var response = await http.get(
                                        '${widget.feed.progressive}?client_id=' +
                                            _clientId);
                                    String streamURL =
                                        json.decode(response.body)['url'];

                                    await _assetsAudioPlayer.open(
                                      Audio.network(
                                        streamURL,
                                        metas: Metas(
                                            title: widget.feed.title,
                                            image: MetasImage.network(
                                                widget.feed.artwork ?? '')),
                                      ),
                                      autoStart: true,
                                      showNotification: false,
                                      playInBackground:
                                          PlayInBackground.enabled,
                                      audioFocusStrategy:
                                          AudioFocusStrategy.request(
                                              resumeAfterInterruption: true,
                                              resumeOthersPlayersAfterDone:
                                                  true),
                                      headPhoneStrategy:
                                          HeadPhoneStrategy.pauseOnUnplug,
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
                widget.feed.image != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Hero(
                          tag: widget.feed.feedID,
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
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: secondHalf.isEmpty
                        ? Text(firstHalf)
                        : Text(
                            flag
                                ? (firstHalf + "...")
                                : (firstHalf + secondHalf),
                          ),
                    // child: Text(widget.feed.content,),
                  ),
                  SizedBox(width: 43),
                  Column(
                    children: [
                      InkWell(
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
                        child: Icon(
                          UniIcon.comment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '댓글',
                        style: body4,
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      InkWell(
                        onTap: _onLikePressed,
                        child: widget.feed.like.contains(widget.userDB.id)
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
                      SizedBox(height: 9),
                      Text(
                        widget.feed.like.length.toString(),
                        style: body3,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  secondHalf.isNotEmpty
                      ? InkWell(
                          child: Container(
                            child: Text(
                              flag ? "더보기" : "줄이기",
                              style: new TextStyle(
                                color: outlineColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              flag = !flag;
                            });
                          },
                        )
                      : Expanded(
                          child: SizedBox(width: 1),
                        ),
                  widget.feed.isEdited == null || widget.feed.isEdited == false
                      ? Text(
                          showTime(widget.feed.time),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: outlineColor,
                          ),
                        )
                      : Text(
                          showTime(widget.feed.time) + ' (수정됨)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: outlineColor,
                          ),
                        ),
                ],
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
