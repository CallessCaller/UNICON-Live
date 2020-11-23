import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/widget/union_page_body.dart';
import 'package:testing_layout/screen/UnionPage/widget/union_page_header.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';

class UnionInfoPage extends StatefulWidget {
  final Artist artist;
  final UserDB userDB;

  const UnionInfoPage({Key key, this.artist, this.userDB}) : super(key: key);
  @override
  _UnionInfoPageState createState() => _UnionInfoPageState();
}

class _UnionInfoPageState extends State<UnionInfoPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.userDB == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            '유니온 피드',
            style: headline2,
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '로그인 후 유니온들의 소식을 둘러보세요!',
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  color: appKeyColor,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  },
                  child: Text('로그인'),
                ),
              ],
            )),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              UnionInfoPageHeader(
                userDB: widget.userDB,
                artist: widget.artist,
              ),
              SizedBox(
                height: 20,
              ),
              UnionPageBody(userDB: widget.userDB, artist: widget.artist),
            ],
          ),
        ),
      ),
    );
  }
}
