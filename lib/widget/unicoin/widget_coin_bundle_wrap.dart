import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin10.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin100.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin1000.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin50.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin500.dart';

List<int> coinBundlePriceList = [
  10,
  50,
  100,
  500,
  1000,
];

List<Widget> coinIconList = [
  Unicoin10(),
  Unicoin50(),
  Unicoin100(),
  Unicoin500(),
  Unicoin1000(),
];

class CoinBundle extends StatefulWidget {
  final UserDB userDB;
  final Artist artist;

  const CoinBundle({
    Key key,
    this.userDB,
    this.artist,
  }) : super(key: key);

  @override
  _CoinBundleState createState() => _CoinBundleState();
}

class _CoinBundleState extends State<CoinBundle> {
  FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: outlineColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildCoinBundle(),
      ),
    );
  }

  List<Widget> _buildCoinBundle() {
    List<Widget> res = [];
    for (int i = 0; i < coinBundlePriceList.length; i++) {
      res.add(
        InkWell(
          child: coinIconList[i],
          onTap: () async {
            int total = 0;
            if (widget.userDB.points - coinBundlePriceList[i] >= 0) {
              var currentTime = Timestamp.now();
              widget.userDB.points =
                  widget.userDB.points - coinBundlePriceList[i];
              widget.userDB.reference.update({'points': widget.userDB.points});
              await widget.artist.reference.get().then((value) {
                total = value.data()['points'];
              }).whenComplete(() {
                widget.artist.reference
                    .update({'points': total + coinBundlePriceList[i]});
              });

              // User -> Union
              widget.userDB.reference.collection('unicoin_history').add({
                'type': 3,
                'who': widget.artist.name,
                'whoseID': widget.artist.id,
                'amount': coinBundlePriceList[i],
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
                'amount': coinBundlePriceList[i],
                'time': currentTime.toDate(),
              });

              Navigator.of(context).pop();

              Widget toast = Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: dialogColor1,
                ),
                child: Text(
                  "${coinBundlePriceList[i]}U 후원하셨습니다.",
                  textAlign: TextAlign.center,
                  style: caption2,
                ),
              );

              fToast.showToast(
                child: toast,
                gravity: ToastGravity.CENTER,
                toastDuration: Duration(seconds: 2),
              );
            } else {
              Widget toast = Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: dialogColor1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      "코인이 모자랍니다.",
                      textAlign: TextAlign.center,
                      style: caption2,
                    ),
                  ],
                ),
              );

              fToast.showToast(
                child: toast,
                gravity: ToastGravity.CENTER,
                toastDuration: Duration(seconds: 2),
              );
            }
          },
        ),
      );
    }
    return res;
  }
}
