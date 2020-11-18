import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/widget/liked_musician_box.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';

class MyMusicianPage extends StatefulWidget {
  final UserDB userDB;
  MyMusicianPage({this.userDB});

  @override
  _MyMusicianPageState createState() => _MyMusicianPageState();
}

class _MyMusicianPageState extends State<MyMusicianPage> {
  @override
  Widget build(BuildContext context) {
    var artistSnapshot = Provider.of<QuerySnapshot>(context);
    List<Artist> artists =
        artistSnapshot.docs.map((e) => Artist.fromSnapshot(e)).toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '마이 유니온',
          style: headline2,
        ),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    SingleChildScrollView(
                      child: Column(
                        children: _musicianBoxes(widget.userDB, artists),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _musicianBoxes(UserDB userDB, List<Artist> artists) {
    List<Widget> result = [];
    for (int i = 0; i < artists.length; i++) {
      if (userDB.follow.contains(artists[i].id)) {
        result.add(LikedMusicianBox(userDB: userDB, artist: artists[i]));
        result.add(
          Divider(
            color: Colors.white,
            height: 5,
          ),
        );
      }
    }
    return result;
  }
}
