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
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SingleChildScrollView(
            child: TextField(
              onTap: () {
                _coinFilter.clear();
              },
              style: TextStyle(
                  fontSize: widgetFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              controller: _coinFilter,
              focusNode: _coinFocus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  labelText: '코인 입력',
                  labelStyle: TextStyle(
                      fontSize: widgetFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MyUnicoinPage(userDB: widget.userDB)));
              },
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      UniIcon.unicoin,
                      color: appKeyColor,
                      size: 25,
                    ),
                    Text(
                      widget.userDB.points.toString(),
                      style: TextStyle(
                          fontSize: textFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            new FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(color: Colors.white)),
                onPressed: () async {
                  _coinFocus.unfocus();
                  int coin = int.parse(_coinFilter.text);
                  int total = 0;
                  if (coin != 0 && widget.userDB.points - coin >= 0) {
                    var currentTime = Timestamp.now();
                    widget.userDB.points = widget.userDB.points - coin;
                    widget.userDB.reference
                        .update({'points': widget.userDB.points});

                    await widget.artist.reference.get().then((value) {
                      total = value.data()['points'];
                    }).whenComplete(() {
                      widget.artist.reference.update({'points': total + coin});
                      widget.live.reference.collection('chitchat').add({
                        'id': widget.userDB.id,
                        'name': '',
                        'is_artist': widget.userDB.isArtist,
                        'content': widget.userDB.name + '님이 $coin 코인 후원!',
                        'time': currentTime.millisecondsSinceEpoch,
                        'gift': true,
                      });
                    });

                    // Donation
                    // User -> Union
                    // type: { 0 : event , 1 : charge , 2 : donated , 3 : donate }
                    widget.userDB.reference.collection('unicoin_history').add({
                      'type': 3,
                      'who': widget.artist.name,
                      'whoseID': widget.artist.id,
                      'amount': coin,
                      'time': currentTime.toDate(),
                    });
                    // Union <- User
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.artist.id)
                        .collection('unicoin_history')
                        .add({
                      'type': 2,
                      'who': widget.userDB.name,
                      'whoseID': widget.userDB.id,
                      'amount': coin,
                      'time': currentTime.toDate(),
                    });

                    _coinFilter.clear();
                    Navigator.of(context).pop();
                  } else {
                    _coinFilter.text = '코인이 모자랍니다';
                  }
                  // setState(() {
                  //   goDown = true;
                  // });
                },
                child: Text(
                  '선물',
                  style: TextStyle(
                      fontSize: textFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )),
          ],
        );
      },
    );
  }
}
