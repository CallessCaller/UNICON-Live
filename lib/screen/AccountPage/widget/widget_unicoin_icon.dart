import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/unicoin_page.dart';

class ToMyUnicoinHistory extends StatelessWidget {
  const ToMyUnicoinHistory({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserDB userDB = Provider.of<UserDB>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyUnicoinPage(
              userDB: userDB,
            ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              UniIcon.unicoin,
              size: 35,
              color: userDB.points != 0 ? appKeyColor : Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              userDB.points.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: userDB.points != 0 ? appKeyColor : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
