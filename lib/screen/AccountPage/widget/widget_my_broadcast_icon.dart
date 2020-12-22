import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/my_broadcast_screen/broadcast_setting.dart';

class MyBroadcast extends StatefulWidget {
  @override
  _MyBroadcastState createState() => _MyBroadcastState();
}

class _MyBroadcastState extends State<MyBroadcast> {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserDB userDB = Provider.of<UserDB>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BroadcastSetting(userDB: userDB),
          ),
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 100) / 4,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UniIcon.ticket_price,
              size: 45,
            ),
            SizedBox(height: 10),
            Text(
              '콘서트 설정',
              style: TextStyle(
                fontSize: widgetFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
