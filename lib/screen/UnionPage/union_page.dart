import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/union_page_header/union_page_header.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';

class UnionInfoPage extends StatefulWidget {
  final Artist artist;
  final UserDB userDB;

  const UnionInfoPage({Key key, this.artist, this.userDB}) : super(key: key);
  @override
  _UnionInfoPageState createState() => _UnionInfoPageState();
}

class _UnionInfoPageState extends State<UnionInfoPage> {
  Lives _findLive(List<Lives> lives) {
    Lives live;
    for (int i = 0; i < lives.length; i++) {
      if (lives[i].id == widget.artist.id) {
        live = lives[i];
        break;
      }
    }
    return live;
  }

  @override
  Widget build(BuildContext context) {
    final lives = Provider.of<List<Lives>>(context);
    final live = _findLive(lives);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              UnionInfoPageHeader(
                userDB: widget.userDB,
                artist: widget.artist,
              ),
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '라이브 다시보기 기능이 추가 될 예정입니다.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
