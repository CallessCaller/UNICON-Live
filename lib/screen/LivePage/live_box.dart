import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/unicoin_page.dart';
import 'package:testing_layout/screen/LivePage/WebStreaming/live_concert.dart';
import 'package:testing_layout/screen/LivePage/WebStreaming/onlyChat.dart';

class LiveBox extends StatefulWidget {
  final Lives live;
  const LiveBox({Key key, this.live}) : super(key: key);

  @override
  _LiveBoxState createState() => _LiveBoxState();
}

class _LiveBoxState extends State<LiveBox> {
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.live.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data);
      },
    );
  }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    Artist artist = Artist.fromSnapshot(snapshot);
    final userDB = Provider.of<UserDB>(context);
    return InkWell(
      onTap: () {
        if (artist.fee == null ||
            artist.fee == 0 ||
            (widget.live.payList != null &&
                widget.live.payList.contains(userDB.id))) {
          notShowAlert(context, userDB, artist, widget.live);
        } else {
          showAlertDialog(context, userDB, artist, widget.live);
        }
      },
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(widgetRadius),
          image: DecorationImage(
            image: NetworkImage(artist.profile),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 10,
              child: Row(
                children: [
                  Icon(
                    UniIcon.account_box,
                    size: 20,
                  ),
                  SizedBox(width: 3),
                  Text(
                    widget.live.viewers.length.toString(),
                    style: TextStyle(
                        fontSize: widgetFontSize, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width * 0.9,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6)),
                clipBehavior: Clip.hardEdge,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(6)),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(artist.profile),
                        ),
                        VerticalDivider(
                          width: 10,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artist.name,
                                style: TextStyle(
                                  fontSize: textFontSize,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '라이브 방송중',
                                style: TextStyle(
                                  fontSize: textFontSize - 2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            artist.fee != 0
                ? Positioned(
                    top: 5,
                    right: 10,
                    child: Row(
                      children: [
                        Icon(
                          UniIcon.unicoin,
                          color: appKeyColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          artist.fee.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: textFontSize,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Positioned(
              bottom: 10,
              right: 5,
              child: Text(
                (DateTime.now().difference(widget.live.time.toDate()).inMinutes)
                        .toString() +
                    '분 전',
                style: TextStyle(
                  fontSize: textFontSize - 2,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return _fetchData(context);
  }
}

void showAlertDialog(
    BuildContext context, UserDB userDB, Artist artist, Lives live) {
  showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          '입장료 ${artist.fee}코인이 차감됩니다.',
          style: TextStyle(
              fontSize: textFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyUnicoinPage(userDB: userDB)));
            },
            child: Text('충전'),
          ),
          FlatButton(
            onPressed: () async {
              int total = 0;
              if (live.payList == null) {
                live.payList = [];
              }

              if (userDB.points >= artist.fee) {
                var currentTime = Timestamp.now();
                userDB.points = userDB.points - artist.fee;
                userDB.reference.update({'points': userDB.points});

                await artist.reference.get().then((value) {
                  total = value.data()['points'];
                }).whenComplete(() async {
                  artist.reference.update({'points': total + artist.fee});

                  // Donation
                  // User -> Union
                  // type: { 0 : event , 1 : charge , 2 : donated , 3 : donate }
                  userDB.reference.collection('unicoin_history').add({
                    'type': 3,
                    'who': artist.name,
                    'whoseID': artist.id,
                    'amount': artist.fee,
                    'time': currentTime.toDate(),
                  });
                  // Union <- User
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(artist.id)
                      .collection('unicoin_history')
                      .add({
                    'type': 2,
                    'who': userDB.name,
                    'whoseID': userDB.id,
                    'amount': artist.fee,
                    'time': currentTime.toDate(),
                  });
                });

                live.payList.add(userDB.id);
                live.viewers.add(userDB.id);
                await live.reference.update(
                    {'viewers': live.viewers, 'pay_list': live.payList});
                if (userDB.id == artist.id) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OnlyChat(
                            live: live,
                          )));
                } else {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LiveConcert(
                            live: live,
                            artist: artist,
                            userDB: userDB,
                          )));
                }
              } else {
                Fluttertoast.showToast(
                  msg: '코인이 모자랍니다.',
                  backgroundColor: Colors.black,
                  fontSize: textFontSize,
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
            },
            child: Text('입장'),
          ),
        ],
      );
    },
  );
}

void notShowAlert(
    BuildContext context, UserDB userDB, Artist artist, Lives live) async {
  live.viewers.add(userDB.id);
  await live.reference.update({'viewers': live.viewers});
  if (userDB.id == artist.id) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OnlyChat(
              live: live,
            )));
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LiveConcert(
              live: live,
              artist: artist,
              userDB: userDB,
            )));
  }
}
