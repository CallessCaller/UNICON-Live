import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (widget.userDB.dislikePeople != null) {
      if (widget.userDB.dislikePeople.contains(widget.artist.id)) {
        return Scaffold(
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
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '차단된 유니언입니다.',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    color: appKeyColor,
                    onPressed: () async {
                      widget.userDB.dislikePeople.remove(widget.artist.id);
                      widget.artist.haters.remove(widget.userDB.id);
                      await widget.userDB.reference.update({
                        'dislikePeople': widget.userDB.dislikePeople,
                      });
                      await widget.artist.reference.update({
                        'haters': widget.artist.haters,
                      });
                      setState(() {});
                    },
                    child: Text('차단 해제'),
                  ),
                ],
              )),
        );
      }
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
          actions: [
            FlatButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: true, // user must tap button!

                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(dialogRadius),
                        ),
                        backgroundColor: dialogColor1,
                        title: Center(
                          child: Text(
                            "신고",
                            style: title1,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "부적절한 이용자 인가요?",
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: FlatButton(
                                    color: dialogColor3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(widgetRadius),
                                    ),
                                    child: Text(
                                      '아니요',
                                      style: TextStyle(
                                        color: dialogColor4,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: FlatButton(
                                    color: appKeyColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(widgetRadius),
                                    ),
                                    child: Text(
                                      '네',
                                      style: subtitle3,
                                    ),
                                    onPressed: () async {
                                      if (widget.userDB.dislikePeople == null) {
                                        await widget.userDB.reference
                                            .update({'dislikePeople': []});
                                      }
                                      widget.userDB.dislikePeople
                                          .add(widget.artist.id);
                                      if (widget.userDB.follow
                                          .contains(widget.artist.id)) {
                                        widget.userDB.follow
                                            .remove(widget.artist.id);
                                      }

                                      await widget.userDB.reference.update({
                                        'dislikePeople':
                                            widget.userDB.dislikePeople,
                                        'follow': widget.userDB.follow
                                      });

                                      if (widget.artist.myPeople
                                          .contains(widget.userDB.id)) {
                                        widget.artist.myPeople
                                            .remove(widget.userDB.id);
                                      }
                                      if (widget.artist.haters == null) {
                                        await widget.artist.reference
                                            .update({'haters': []});
                                      }
                                      widget.artist.haters
                                          .add(widget.userDB.id);
                                      await widget.artist.reference.update({
                                        'my_people': widget.artist.myPeople,
                                        'haters': widget.artist.haters,
                                      });
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
              child: Text(
                '신고',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ],
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
