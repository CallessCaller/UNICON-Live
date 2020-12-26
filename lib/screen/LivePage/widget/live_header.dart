import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/liveHeader.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/UnionPage/union_page.dart';

class LiveHeader extends StatefulWidget {
  final UserDB userDB;
  LiveHeader({this.userDB});
  @override
  State<StatefulWidget> createState() {
    return _LiveHeaderState();
  }
}

class _LiveHeaderState extends State<LiveHeader> {
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('LiveHeader').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<LiveHeaderModel> liveHeader =
        snapshot.map((e) => LiveHeaderModel.fromSnapshot(e)).toList();
    return SizedBox(
      // HEADER 비율: width / height -> 3:2
      height: MediaQuery.of(context).size.width / 3 * 2,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        onImageTap: (int index) async {
          if (liveHeader[index].id != null && liveHeader[index].id != '') {
            var artistSanpshot = await FirebaseFirestore.instance
                .collection('User')
                .doc(liveHeader[index].id)
                .get();
            Artist artist = Artist.fromSnapshot(artistSanpshot);

            var userSnapshot = await FirebaseFirestore.instance
                .collection('User')
                .doc(widget.userDB.id)
                .get();
            UserDB userDB = UserDB.fromSnapshot(userSnapshot);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UnionInfoPage(
                      artist: artist,
                      userDB: userDB,
                    )));
          }
        },
        autoplay: true,
        animationCurve: Curves.easeInOut,
        autoplayDuration: Duration(seconds: 5),
        images: liveHeader.map((e) => NetworkImage(e.image)).toList(),
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotIncreasedColor: Colors.white,
        dotBgColor: Colors.transparent,
        indicatorBgPadding: 10.0,
        animationDuration: Duration(milliseconds: 500),
        boxFit: BoxFit.fitWidth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
