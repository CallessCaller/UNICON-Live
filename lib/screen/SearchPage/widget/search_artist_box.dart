import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/union_page.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';

class SearchArtistBox extends StatefulWidget {
  final Artist artist;
  final UserDB userDB;
  SearchArtistBox({this.artist, this.userDB});
  @override
  _SearchArtistBoxState createState() => _SearchArtistBoxState();
}

class _SearchArtistBoxState extends State<SearchArtistBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UnionInfoPage(
                  artist: widget.artist,
                  userDB: widget.userDB,
                ),
              ),
            );
          },
          child: Container(
            height: (MediaQuery.of(context).size.width - 60) / 2,
            width: (MediaQuery.of(context).size.width - 60) / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.artist.resizedProfile != null &&
                          widget.artist.resizedProfile != ''
                      ? widget.artist.resizedProfile
                      : widget.artist.profile),
                )),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5),
          alignment: Alignment.bottomCenter,
          child: Text(
            widget.artist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: caption1,
          ),
        ),
      ],
    );
  }
}
