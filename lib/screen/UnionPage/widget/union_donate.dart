import 'package:flutter/material.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/unicoin_page.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/webConstant.dart';

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
            barrierDismissible: false,
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
                    TextField(
                      controller: _coinFilter,
                      onTap: () {
                        _coinFilter.clear();
                      },
                      textAlign: TextAlign.center,
                      style: subtitle1,
                      keyboardType: TextInputType.number,
                      focusNode: _coinFocus,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: outlineColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appKeyColor,
                          ),
                        ),
                        hintText: '코인 입력',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        SizedBox(width: 10),
                        Expanded(
                          child: FlatButton(
                            color: appKeyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widgetRadius),
                            ),
                            onPressed: () async {
                              _coinFocus.unfocus();
                              int coin = int.parse(_coinFilter.text);
                              int total = 0;
                              if (coin != 0 &&
                                  widget.userDB.points - coin >= 0) {
                                var currentTime = Timestamp.now();
                                widget.userDB.points =
                                    widget.userDB.points - coin;
                                widget.userDB.reference
                                    .update({'points': widget.userDB.points});

                                await widget.artist.reference
                                    .get()
                                    .then((value) {
                                  total = value.data()['points'];
                                }).whenComplete(() {
                                  widget.artist.reference
                                      .update({'points': total + coin});
                                });

                                // Donation
                                // User -> Union
                                // type: { 0 : event , 1 : charge , 2 : donated , 3 : donate }
                                widget.userDB.reference
                                    .collection('unicoin_history')
                                    .add({
                                  'type': 3,
                                  'who': widget.artist.name,
                                  'whoseID': widget.artist.id,
                                  'amount': coin,
                                  'time': currentTime.toDate(),
                                });
                                // Union <- User
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(widget.artist.id)
                                    .collection('unicoin_history')
                                    .add({
                                  'type': 2,
                                  'who': widget.userDB.name,
                                  'whoseID': widget.userDB.id,
                                  'amount': coin,
                                  'time': currentTime.toDate(),
                                });

                                _coinFilter.clear();
                                Navigator.of(context).pop();
                              } else {
                                _coinFilter.text = '코인이 모자랍니다';
                              }
                              setState(() {
                                goDown = true;
                              });
                            },
                            child: Text(
                              '선물',
                              style: subtitle3,
                            ),
                          ),
                        ),
                      ],
                    )
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
