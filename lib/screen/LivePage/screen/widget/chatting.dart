import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/unicoin_page.dart';
import 'package:testing_layout/screen/LivePage/screen/live_concert.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/webConstant.dart';
import 'package:testing_layout/widget/unicoin/widget_coin_bundle_wrap.dart';

FocusNode chatFocusNode = new FocusNode();

class ChatWidget extends StatefulWidget {
  final double keyboardHeight;
  final Artist artist;
  final Lives live;
  final UserDB userDB;
  final double width;
  ChatWidget(
      {this.artist, this.live, this.width, this.userDB, this.keyboardHeight});
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final ScrollController scrollController = new ScrollController();
  final _filter = TextEditingController();
  final _coinFilter = new TextEditingController();
  final _coinFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }
  }

  @override
  void dispose() {
    _filter.dispose();
    _coinFilter.dispose();
    _coinFocus.dispose();
    super.dispose();
  }

  List<Widget> results = [];
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.live.reference
          .collection('chitchat')
          .orderBy('time', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    void _scrollDown() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: new Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      return;
    }

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    results = snapshot
        .map((d) =>
            nameText(d.data()['name'], d.data()['content'], d.data()['gift']))
        .toList()
        .reversed
        .toList();

    if (widget.width != 0) {
      Timer(Duration(milliseconds: 1000), _scrollDown);
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(microseconds: 500),
          padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
          height: chatFocusNode.hasFocus
              ? _height - widget.keyboardHeight - 50
              : _height - 50,
          width: widget.width == 0
              ? widget.width
              : chatFocusNode.hasFocus
                  ? _width * 0.5 - 10
                  : widget.width,
          decoration: BoxDecoration(
              color: Color.fromRGBO(232, 232, 232, 1),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15))),
          child: InkWell(
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
                _filter.clear();
              });
            },
            child: ListView(
              controller: scrollController,
              children: results,
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(microseconds: 500),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 50,
          width: widget.width == 0
              ? widget.width
              : chatFocusNode.hasFocus
                  ? _width * 0.5 - 10
                  : widget.width,
          color: Colors.white,
          child: Row(
            children: [
              InkWell(
                  child: Icon(
                    UniIcon.unicoin,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onTap: () {
                    _showDialog();
                  }),
              SizedBox(
                width: 10,
              ),
              new Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  width: _width * 0.5,
                  child: TextField(
                    onTap: () {
                      artistTap = false;
                      Timer(Duration(milliseconds: 1000), _scrollDown);
                    },
                    autocorrect: false,
                    maxLines: 1,
                    onEditingComplete: () async {
                      bool _live = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.artist.id)
                          .get()
                          .then((value) => value.data()['live_now']);
                      if (_filter.text.length != 0 && _live == true) {
                        await widget.live.reference.collection('chitchat').add({
                          'id': widget.userDB.id,
                          'name': widget.userDB.name,
                          'is_artist': widget.userDB.isArtist,
                          'content': _filter.text,
                          'time': Timestamp.now().millisecondsSinceEpoch,
                          'gift': false,
                        });
                      }

                      _filter.clear();
                    },
                    style:
                        TextStyle(fontSize: textFontSize, color: Colors.black),
                    focusNode: chatFocusNode,
                    controller: _filter,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        suffixIcon: chatFocusNode.hasFocus
                            ? IconButton(
                                splashRadius: 0.1,
                                icon: Icon(
                                  Icons.send,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                onPressed: () async {
                                  bool _live = await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(widget.artist.id)
                                      .get()
                                      .then(
                                          (value) => value.data()['live_now']);
                                  if (_filter.text.length != 0 &&
                                      _live == true) {
                                    await widget.live.reference
                                        .collection('chitchat')
                                        .add({
                                      'id': widget.userDB.id,
                                      'name': widget.userDB.name,
                                      'is_artist': widget.userDB.isArtist,
                                      'content': _filter.text,
                                      'time': Timestamp.now()
                                          .millisecondsSinceEpoch,
                                      'gift': false,
                                    });
                                  }

                                  _filter.clear();
                                },
                              )
                            : SizedBox(),
                        fillColor: Color.fromRGBO(232, 232, 232, 1),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(232, 232, 232, 1),
                            ),
                            borderRadius: BorderRadius.circular(11)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(232, 232, 232, 1),
                            ),
                            borderRadius: BorderRadius.circular(11)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(232, 232, 232, 1),
                            ),
                            borderRadius: BorderRadius.circular(11)),
                        hintText: '채팅',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: textFontSize)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dialogRadius),
          ),
          backgroundColor: dialogColor1.withOpacity(0.5),
          title: Center(
            child: Text(
              '응원하기!',
              style: title1,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MyUnicoinPage(userDB: widget.userDB),
                    ),
                  );
                },
                child: Container(
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 30,
                        child: Icon(
                          UniIcon.unicoin,
                          color: appKeyColor,
                        ),
                      ),
                      SizedBox(width: 3),
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          widget.userDB.points.toString(),
                          style: subtitle2,
                        ),
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          ' (보유 유니코인)',
                          style: TextStyle(
                            color: outlineColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              CoinBundle(
                userDB: widget.userDB,
                artist: widget.artist,
              ),
              SizedBox(height: 10),
              Text(
                '후원하신 상품은 유니온에게 전달되며, 환불 받으실 수 없습니다.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
