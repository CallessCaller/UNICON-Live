import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/widget/live_box.dart';

// class HotLives extends StatefulWidget {
//   final List<Lives> lives;
//   final UserDB userDB;

//   const HotLives({Key key, this.lives, this.userDB})
//       : super(key: key);
//   @override
//   _HotLivesState createState() => _HotLivesState();
// }

// class _HotLivesState extends State<HotLives> {
//   @override
//   Widget build(BuildContext context) {
//     var artistSnapshot = Provider.of<QuerySnapshot>(context);
//     final artists = artistSnapshot.docs.map((e) => Artist.fromSnapshot(e)).toList();
//     List<Widget> result = [];
//     widget.lives.sort((a, b) => b.viewers.length.compareTo(a.viewers.length));
//     for (int i = 0; i < widget.lives.length; i++) {
//       if (result.length == 10) break;

//       int index = artists
//           .indexWhere((artist) => artist.id.contains(widget.lives[i].id));
//       result.add(slider(
//           context, artists[index], widget.lives[i], widget.userDB));
//     }
//     if (result.length == 0) {
//       result.add(Center(
//         child: Text('현재 라이브가 없습니다.'),
//       ));
//     }
//     return CarouselSlider(
//       options: CarouselOptions(
//         enableInfiniteScroll: true,
//         viewportFraction: 0.5,
//         height: 150,
//         aspectRatio: 2,
//         enlargeCenterPage: true,
//         scrollDirection: Axis.horizontal,
//         autoPlay: false,
//       ),
//       items: result,
//     );
//   }
// }

List<Widget> hotLive(BuildContext context, List<Lives> lives, UserDB userDB) {
  var artistSnapshot = Provider.of<QuerySnapshot>(context);
  final artists =
      artistSnapshot.docs.map((e) => Artist.fromSnapshot(e)).toList();
  List<Widget> result = [];
  lives.sort((a, b) => b.viewers.length.compareTo(a.viewers.length));
  for (int i = 0; i < lives.length; i++) {
    if (result.length == 10) break;

    int index = artists.indexWhere((artist) => artist.id.contains(lives[i].id));
    if (artists[index].liveNow == true) {
      result.add(slider(context, artists[index], lives[i], userDB));
    }
  }
  if (result.length == 0) {
    result.add(Center(
      child: Text('현재 라이브가 없습니다.'),
    ));
  }
  return result;
}

Widget slider(BuildContext context, Artist artist, Lives live, UserDB userDB) {
  String backgroundImage = artist.liveImage == null
      ? artist.resizedProfile != null && artist.resizedProfile != ''
          ? artist.resizedProfile
          : artist.profile
      : artist.resizedLiveImage != null && artist.resizedLiveImage != ''
          ? artist.resizedLiveImage
          : artist.liveImage;
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
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
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          child: Stack(
            children: <Widget>[
              Image.network(
                backgroundImage,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(8)),
                      color: Colors.black.withOpacity(0.3)),
                  child: Text(
                    artist.name +
                        ' - ' +
                        live.viewers.length.toString() +
                        '명 시청중',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widgetFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
