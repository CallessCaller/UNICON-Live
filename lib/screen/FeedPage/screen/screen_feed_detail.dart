import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:testing_layout/components/constant.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              radius: 25.0,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  child: Text(
                                    snapshot.data()['name'],
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  showTime(widget.feed.time) +
                                      ' - ' +
                                      widget.feed.like.length.toString() +
                                      ' Likes',
                                  style: TextStyle(
                                    fontSize: textFontSize,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          widget.feed.progressive != null
                              ? IconButton(
                                  icon: Icon(
                                    MdiIcons.play,
                                    size: 30,
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
                                          ),
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
                                )
                              : SizedBox(),
                          SizedBox(
                            width: 5,
                          ),
                          widget.feed.id == widget.userDB.id
                              ? IconButton(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    size: 20,
                                  ),
                                  onPressed: () {})
                              : IconButton(
                                  icon: Icon(
                                    widget.feed.like.contains(widget.userDB.id)
                                        ? MdiIcons.heart
                                        : MdiIcons.heartOutline,
                                    color: appKeyColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _onLikePressed();
                                  }),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    widget.feed.image != null
                        ? Hero(
                            tag: widget.feed.feedID,
                            child: CachedNetworkImage(
                              imageUrl: widget.feed.image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageProvider),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Divider(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.feed.content,
                        maxLines: 1000,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textFontSize,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: Colors.white,
                      ),
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width - 40,
                      height: 22,
                      child: Container(
                        height: 20,
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _controller,
                          onEditingComplete: () async {
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
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                gapPadding: 0,
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                gapPadding: 0,
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                gapPadding: 0,
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              hintText: 'Add a comment...',
                              hintStyle: TextStyle(
                                  fontSize: widgetFontSize,
                                  color: Colors.black)),
                          style: TextStyle(
                              fontSize: widgetFontSize, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CommentBoxes(
                      feed: widget.feed,
                      userId: widget.userDB.id,
                    ),
                    SizedBox(
                      height: 25,
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
}
