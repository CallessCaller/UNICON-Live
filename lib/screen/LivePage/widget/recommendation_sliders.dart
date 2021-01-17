import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/widget/live_box.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';

class HotLives extends StatefulWidget {
  final UserDB userDB;

  const HotLives({Key key, this.userDB}) : super(key: key);
  @override
  _HotLivesState createState() => _HotLivesState();
}

class _HotLivesState extends State<HotLives> {
  //Container HotliveList(){return Container();}

  @override
  Widget build(BuildContext context) {
    var artistSnapshot = Provider.of<QuerySnapshot>(context);
    final artists =
        artistSnapshot.docs.map((e) => Artist.fromSnapshot(e)).toList();
    final lives = Provider.of<List<Lives>>(context);
    List<Widget> result = [];
    lives.sort((a, b) => b.viewers.length.compareTo(a.viewers.length));
    for (int i = 0; i < lives.length; i++) {
      if (result.length == 10) break;

      int index =
          artists.indexWhere((artist) => artist.id.contains(lives[i].id));
      if (artists[index].liveNow == true) {
        result.add(slider(context, artists[index], lives[i], widget.userDB));
        result.add(VerticalDivider(width: 15, color: Colors.transparent));
      }
    }
    if (result.length == 0) {
      result.add(Center(
        child: Text('현재 라이브가 없습니다.'),
      ));
    }
    /*
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: true,
        viewportFraction: 0.5,
        height: 150,
        aspectRatio: 2,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: false,
      ),
      items: result,
    );*/
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.width * 0.6 * (0.5 + 0.22 + 0.1),
      child: ListView(scrollDirection: Axis.horizontal, children: [
        Row(
          children: result,
        )
      ]),
    );
  }
}

// List<Widget> hotLive(BuildContext context, List<Lives> lives, UserDB userDB) {
//   var artistSnapshot = Provider.of<QuerySnapshot>(context);
//   final artists =
//       artistSnapshot.docs.map((e) => Artist.fromSnapshot(e)).toList();
//   List<Widget> result = [];
//   lives.sort((a, b) => b.viewers.length.compareTo(a.viewers.length));
//   for (int i = 0; i < lives.length; i++) {
//     if (result.length == 10) break;

//     int index = artists.indexWhere((artist) => artist.id.contains(lives[i].id));
//     if (artists[index].liveNow == true) {
//       result.add(slider(context, artists[index], lives[i], userDB));
//     }
//   }
//   if (result.length == 0) {
//     result.add(Center(
//       child: Text('현재 라이브가 없습니다.'),
//     ));
//   }
//   return result;
// }

Widget slider(BuildContext context, Artist artist, Lives live, UserDB userDB) {
  String backgroundImage = artist.liveImage == null
      ? artist.resizedProfile != null && artist.resizedProfile != ''
          ? artist.resizedProfile
          : artist.profile
      : artist.resizedLiveImage != null && artist.resizedLiveImage != ''
          ? artist.resizedLiveImage
          : artist.liveImage;
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
    child: InkWell(
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
          notShowAlert(context, userDB, artist, live);
        } else {
          showAlertDialog(context, userDB, artist, live);
        }
      },
      child: Column(children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.6 / 2,
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: ClipRRect(
            // borderRadius: BorderRadius.all(Radius.circular(7.0)),
            child: Stack(
              children: <Widget>[
                Image.network(
                  backgroundImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Row(
                    children: [
                      Icon(
                        UniIcon.profile,
                        size: 20,
                      ),
                      SizedBox(width: 3),
                      Text(
                        live.viewers.length.toString() + '명',
                        style: body4,
                        // TextStyle(
                        //     fontSize: widgetFontSize-1, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Color(0xff313131),
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(10.0))),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6 * 0.22,
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              VerticalDivider(
                width: 5,
                color: Colors.transparent,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.liveTitle != null || artist.liveTitle != ''
                          ? '${artist.name}님의 라이브 방송'
                          : '라이브 방송중',
                      style: caption1,
                      // TextStyle(
                      //   fontSize: textFontSize +4,//- 2,
                      //   color: Colors.white,
                      // ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      (artist.liveTitle != null && artist.liveTitle != ''
                                  ? artist.liveTitle
                                  : artist.name)
                              .toString() +
                          '  |  ' +
                          (DateTime.now()
                                  .difference(live.time.toDate())
                                  .inMinutes)
                              .toString() +
                          '분 전',
                      style: caption2,
                      // TextStyle(
                      //   fontSize: textFontSize -2,//+4,
                      //   color: Colors.white,
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    ),
  );
}
