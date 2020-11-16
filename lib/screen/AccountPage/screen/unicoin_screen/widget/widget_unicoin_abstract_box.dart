import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';

class UnicoinAbstractBox extends StatefulWidget {
  final UserDB userDB;

  const UnicoinAbstractBox({Key key, this.userDB}) : super(key: key);
  @override
  _UnicoinAbstractBoxState createState() => _UnicoinAbstractBoxState();
}

class _UnicoinAbstractBoxState extends State<UnicoinAbstractBox> {
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
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widgetRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            UniIcon.unicoin,
            size: 30,
            color: _userDB.points != 0 ? appKeyColor : Colors.grey,
          ),
          SizedBox(width: 5),
          Text(
            _userDB.points.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: subtitleFontSize + 2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
