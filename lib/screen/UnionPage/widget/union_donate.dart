import 'package:flutter/material.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/unicoin_page.dart';
import 'package:testing_layout/widget/unicoin/widget_coin_bundle_wrap.dart';

class UnionDonate extends StatefulWidget {
  final UserDB userDB;
  final Artist artist;
  UnionDonate({this.userDB, this.artist});

  @override
  _UnionDonateState createState() => _UnionDonateState();
}

class _UnionDonateState extends State<UnionDonate> {
  final _coinFilter = new TextEditingController();
  final _coinFocus = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2 + 33.5,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              UniIcon.unicoin,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 2),
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '응원하기',
                    style: body2,
                  ),
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widgetRadius),
          ),
        ),
        height: 30,
        color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
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
                    '응원하기!',
                    style: title1,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MyUnicoinPage(userDB: widget.userDB),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 30,
                              child: Icon(
                                UniIcon.unicoin,
                                color: appKeyColor,
                              ),
                            ),
                            SizedBox(width: 3),
                            Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                widget.userDB.points.toString(),
                                style: subtitle2,
                              ),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                ' (보유 유니코인)',
                                style: TextStyle(
                                  color: outlineColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CoinBundle(
                      userDB: widget.userDB,
                      artist: widget.artist,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '후원하신 상품은 유니온에게 전달되며, 환불 받으실 수 없습니다.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: dialogColor3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widgetRadius),
                            ),
                            onPressed: () {
                              _coinFilter.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: dialogColor4,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
