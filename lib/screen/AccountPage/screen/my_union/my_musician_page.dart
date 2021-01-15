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
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";
  @override
  _MyMusicianPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text.toLowerCase();
      });
    });
  }

  Widget _buildList(BuildContext context, List<Widget> artist) {
    for (int i = 1; i < artist.length; i++) {
      artist.removeAt(i);
    }
    List<Widget> searchResults = [];
    // var shuffledList = shuffle(artists.docs);
    for (LikedMusicianBox select in artist) {
      if (searchResults.length >= 30) break;
      if (select.artist.name.toString().toLowerCase().contains(_searchText)) {
        searchResults.add(select);
        searchResults.add(
          Divider(
            color: Colors.white,
            height: 5,
          ),
        );
      }
    }

    if (searchResults.length != 0) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: searchResults,
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        alignment: Alignment.center,
        child: Text('검색 결과가 없습니다.'),
      );
    }
  }

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
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
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
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  height: 50,
                  child: TextField(
                    autocorrect: false,
                    focusNode: focusNode,
                    style:
                        TextStyle(color: Colors.white, fontSize: textFontSize),
                    controller: _filter,
                    decoration: InputDecoration(
                      suffixIcon: focusNode.hasFocus
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _filter.clear();
                                    _searchText = "";
                                    focusNode.unfocus();
                                  });
                                },
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      contentPadding: EdgeInsets.all(10.0),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      hintText: ' 검색',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: textFontSize,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius:
                            BorderRadius.all(Radius.circular(widgetRadius)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius:
                            BorderRadius.all(Radius.circular(widgetRadius)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius:
                            BorderRadius.all(Radius.circular(widgetRadius)),
                      ),
                    ),
                  ),
                ),
              ),
              _searchText == ''
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
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
                    )
                  : _buildList(context, _musicianBoxes(widget.userDB, artists)),
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
