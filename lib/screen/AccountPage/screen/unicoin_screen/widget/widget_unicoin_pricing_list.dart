import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/widget/payModule.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/widget/widget_unicoin_abstract_box.dart';

class UnicoinPricingList extends StatefulWidget {
  final UserDB userDB;
  UnicoinPricingList({this.userDB});

  @override
  _UnicoinPricingListState createState() => _UnicoinPricingListState();
}

class _UnicoinPricingListState extends State<UnicoinPricingList> {
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
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(widgetRadius),
      ),
      child: Column(
        children: [
          Text(
            '유니코인 가격표',
            style: TextStyle(
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          priceTag(_userDB, 10, getPrice('10').toString()),
          priceTag(_userDB, 20, getPrice('20').toString()),
          priceTag(_userDB, 50, getPrice('50').toString()),
          priceTag(_userDB, 100, getPrice('100').toString()),
          priceTag(_userDB, 500, getPrice('500').toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  Widget priceButton(UserDB userdB, int amount, String price) {
    return FlatButton(
      minWidth: 95,
      height: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      color: appKeyColor,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PayModule(
                  userDB: userdB,
                  coinAmount: amount,
                )));
      },
      child: Text(
        price + '원',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: textFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget priceTag(UserDB userDB, int amount, String price) {
    return Row(
      children: [
        Icon(UniIcon.unicoin),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 30,
          alignment: Alignment.center,
          child: Text(
            amount.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: textFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
            child: Container(
          child: Text(''),
        )),
        priceButton(userDB, amount, price),
      ],
    );
  }
}
