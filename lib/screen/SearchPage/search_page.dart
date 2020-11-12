import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/liked_musician_box.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/SearchPage/searched_artists.dart';

class SearchPage extends StatefulWidget {
  SearchPage({
    Key key,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = TextEditingController();

  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _SearchPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text.toLowerCase();
      });
    });
  }
  Widget _buildList(BuildContext context, QuerySnapshot artists) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot artist in artists.docs) {
      if (searchResults.length >= 30) break;
      if (artist.data().toString().toLowerCase().contains(_searchText)) {
        searchResults.add(artist);
      }
    }

    if (searchResults.length != 0) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children:
              searchResults.map((e) => _buildListItem(context, e)).toList(),
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot artist) {
    final userDB = Provider.of<UserDB>(context);
    final musician = Artist.fromSnapshot(artist);
    return Column(
      children: [
        InkWell(
          child: LikedMusicianBox(userDB: userDB, artist: musician),
        ),
        Divider(
          color: Colors.white,
          height: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var artists = Provider.of<QuerySnapshot>(context);
    final musicians = artists.docs.map((e) => Artist.fromSnapshot(e)).toList();
    var userDB = Provider.of<UserDB>(context);
    return Scaffold(
      backgroundColor: Colors.black,
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
              SizedBox(
                height: 20,
              ),
              _searchText == ''
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '장르별',
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 330,
                            child: GridView.count(
                              scrollDirection: Axis.horizontal,
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              children: List.generate(
                                genreTotalList.length,
                                (index) {
                                  return _buildGenreCard(
                                      index, musicians, userDB);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            height: 30,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '무드별',
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 330,
                            child: GridView.count(
                              scrollDirection: Axis.horizontal,
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              children: List.generate(
                                genreTotalList.length,
                                (index) {
                                  return _buildMoodCard(
                                      index, musicians, userDB);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildList(context, artists),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(int index, List<Artist> artists, UserDB userDB) {
    return InkWell(
      onTap: () {
        List<Artist> results = [];
        artists.forEach((element) {
          if (element.genre != null &&
              element.genre.contains(genreTotalList[index])) {
            results.add(element);
          }
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchedArtist(results, userDB)));
      },
      child: CachedNetworkImage(
        imageUrl: pictures[index],
        imageBuilder: (context, imageProvider) => Stack(
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                borderRadius: BorderRadius.all(Radius.circular(widgetRadius)),
                image: DecorationImage(
                  image: imageProvider,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.1),
                    BlendMode.darken,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Text(
                  genreTotalList[index],
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(int index, List<Artist> artists, UserDB userDB) {
    return InkWell(
      onTap: () {
        List<Artist> results = [];
        artists.forEach((element) {
          if (element.mood != null &&
              element.mood.contains(moodTotalList[index])) {
            results.add(element);
          }
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchedArtist(results, userDB)));
      },
      child: CachedNetworkImage(
        imageUrl: pictures[index],
        imageBuilder: (context, imageProvider) => Stack(
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                borderRadius: BorderRadius.all(Radius.circular(widgetRadius)),
                image: DecorationImage(
                  image: imageProvider,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.1),
                    BlendMode.darken,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Text(
                  moodTotalList[index],
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
