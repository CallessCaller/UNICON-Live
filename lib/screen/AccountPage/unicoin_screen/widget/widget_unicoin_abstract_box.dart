import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/payModule.dart';

class UnicoinAbstractBox extends StatefulWidget {
  final UserDB userDB;

  const UnicoinAbstractBox({Key key, this.userDB}) : super(key: key);
  @override
  _UnicoinAbstractBoxState createState() => _UnicoinAbstractBoxState();
}

class _UnicoinAbstractBoxState extends State<UnicoinAbstractBox> {
  TextEditingController coinAmount = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userDB.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        return _buildBody(context, snapshot.data);
      },
    );
  }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    UserDB _userDB = UserDB.fromSnapshot(snapshot);
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(widgetRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    UniIcon.unicoin,
                    color: _userDB.points != 0 ? appKeyColor : Colors.grey,
                  ),
                  SizedBox(width: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _userDB.points.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  focusNode: _focusNode,
                  controller: coinAmount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: '충전 코인 입력',
                      hintStyle:
                          TextStyle(fontSize: textFontSize, color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      focusedBorder: OutlineInputBorder(
                          gapPadding: 0,
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7)),
                      border: OutlineInputBorder(
                          gapPadding: 0,
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(7))),
                ),
              ),
              FlatButton(
                minWidth: 44,
                height: 30,
                color: appKeyColor,
                disabledColor: Colors.grey,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(widgetRadius),
                ),
                onPressed: coinAmount.text == ''
                    ? null
                    : int.parse(coinAmount.text) < 500
                        ? null
                        : () {
                            int stringToInt = int.parse(coinAmount.text);
                            if (stringToInt < 500) {
                              Fluttertoast.showToast(
                                msg: '500코인 이상 입력해주세요.',
                                backgroundColor: Colors.black,
                                fontSize: textFontSize,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PayModule(
                                        userDB: _userDB,
                                        coinAmount: stringToInt,
                                      )));
                            }

                            coinAmount.text = '';
                            _focusNode.unfocus();
                          },
                child: Text(
                  '충전',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(coinAmount.text == ''
                  ? ''
                  : int.parse(coinAmount.text) < 500
                      ? '500코인 이상부터 자유 충전 가능합니다.'
                      : '${getPrice(coinAmount.text)}원')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}

int getPrice(String coinAmount) {
  int coinInt = int.parse(coinAmount);
  int coinPrice = 0;
  if (coinInt < 50) {
    coinPrice = coinInt * 120;
  } else if (coinInt < 100) {
    coinPrice = coinInt * (120 * 0.98).round();
  } else if (coinInt < 500) {
    coinPrice = coinInt * (120 * 0.95).round();
  } else {
    coinPrice = coinInt * (120 * 0.97).round();
  }
  return (coinPrice);
}
