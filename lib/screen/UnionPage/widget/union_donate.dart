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
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              elevation: 0,
              backgroundColor: Color.fromRGBO(232, 232, 232, 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: SingleChildScrollView(
                child: TextField(
                  onTap: () {
                    _coinFilter.clear();
                  },
                  style: TextStyle(
                      fontSize: widgetFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  controller: _coinFilter,
                  focusNode: _coinFocus,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: '코인 입력',
                      labelStyle: TextStyle(
                          fontSize: widgetFontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MyUnicoinPage(userDB: widget.userDB)));
                  },
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          UniIcon.unicoin,
                          color: appKeyColor,
                          size: 25,
                        ),
                        Text(
                          widget.userDB.points.toString(),
                          style: TextStyle(
                              fontSize: textFontSize,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                new FlatButton(
                    onPressed: () async {
                      _coinFocus.unfocus();
                      int coin = int.parse(_coinFilter.text);
                      int total = 0;
                      if (coin != 0 && widget.userDB.points - coin >= 0) {
                        var currentTime = Timestamp.now();
                        widget.userDB.points = widget.userDB.points - coin;
                        widget.userDB.reference
                            .update({'points': widget.userDB.points});

                        await widget.artist.reference.get().then((value) {
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
                      style: TextStyle(
                          fontSize: textFontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            );
          },
        );
      },
      child: Stack(
        children: [
          Container(
            height: 30,
            width: 190,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(widgetRadius)),
            child: Center(
              child: Text('응원하기'),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(
              UniIcon.soundcloud,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
