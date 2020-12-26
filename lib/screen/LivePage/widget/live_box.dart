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
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/unicoin_page.dart';

import 'package:testing_layout/screen/LivePage/screen/live_concert.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/onlyChat.dart';

// TODO: 라이브 시청자 수 새 필드 생성
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
    var userDB = Provider.of<UserDB>(context);

    if (artist.liveNow == false) {
      return SizedBox();
    } else {
      return InkWell(
        onTap: () async {
          DocumentSnapshot liveDoc = await FirebaseFirestore.instance
              .collection('LiveTmp')
              .doc(artist.id)
              .get();
          List<dynamic> payList = liveDoc.data()['payList'];
          if (artist.fee == null ||
              artist.id == userDB.id ||
              artist.fee == 0 ||
              (payList != null && payList.contains(userDB.id)) ||
              (userDB.admin != null && userDB.admin)) {
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
              image: artist.liveImage == null
                  ? artist.resizedProfile != null && artist.resizedProfile != ''
                      ? NetworkImage(artist.resizedProfile)
                      : NetworkImage(artist.profile)
                  : artist.resizedLiveImage != null &&
                          artist.resizedLiveImage != ''
                      ? NetworkImage(artist.resizedLiveImage)
                      : NetworkImage(artist.liveImage),
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
                      UniIcon.profile,
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
                bottom: 5,
                left: 5,
                width: MediaQuery.of(context).size.width * 0.9 - 12,
                height: 55,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(6)),
                  clipBehavior: Clip.antiAlias,
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
                            backgroundImage: artist.resizedProfile != null &&
                                    artist.resizedProfile != ''
                                ? NetworkImage(artist.resizedProfile)
                                : NetworkImage(artist.profile),
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
                                  artist.liveTitle != null &&
                                          artist.liveTitle != ''
                                      ? artist.liveTitle
                                      : artist.name,
                                  style: TextStyle(
                                    fontSize: textFontSize,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  artist.liveTitle != null &&
                                          artist.liveTitle != ''
                                      ? '${artist.name}님의 라이브 방송'
                                      : '라이브 방송중',
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
                  (DateTime.now()
                              .difference(widget.live.time.toDate())
                              .inMinutes)
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

                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userDB.id)
                    .update({'points': userDB.points});

                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(artist.id)
                    .get()
                    .then((value) {
                  total = value.data()['points'];
                }).whenComplete(() async {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(artist.id)
                      .update({'points': total + artist.fee});

                  // Donation
                  // User -> Union
                  // type: { 0 : event , 1 : charge , 2 : donated , 3 : donate }
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userDB.id)
                      .collection('unicoin_history')
                      .add({
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

                DocumentSnapshot liveDoc = await FirebaseFirestore.instance
                    .collection('LiveTmp')
                    .doc(artist.id)
                    .get();
                List<dynamic> payList = liveDoc.data()['pay_list'];
                List<dynamic> viewers = liveDoc.data()['viewers'];

                if (!viewers.contains(userDB.id)) {
                  viewers.add(userDB.id);
                  await FirebaseFirestore.instance
                      .collection('LiveTmp')
                      .doc(artist.id)
                      .update({'viewers': viewers});
                }
                if (!payList.contains(userDB.id)) {
                  payList.add(userDB.id);
                  await FirebaseFirestore.instance
                      .collection('LiveTmp')
                      .doc(artist.id)
                      .update({'pay_list': payList});
                }

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
  if (userDB.id != artist.id) {
    DocumentSnapshot liveDoc = await FirebaseFirestore.instance
        .collection('LiveTmp')
        .doc(artist.id)
        .get();
    List<dynamic> viewers = liveDoc.data()['viewers'];
    if (!viewers.contains(userDB.id)) {
      viewers.add(userDB.id);
      await FirebaseFirestore.instance
          .collection('LiveTmp')
          .doc(artist.id)
          .update({'viewers': viewers});
    }
  }

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
