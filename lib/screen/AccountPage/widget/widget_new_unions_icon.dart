import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/union_recommend/request_new_musician_page.dart';

class NewUnionsIcon extends StatelessWidget {
  final UserDB userDB;
  const NewUnionsIcon({
    Key key,
    this.userDB,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RequestNewMusicianPage(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UniIcon.new_union,
              size: 45,
            ),
            SizedBox(height: 10),
            Text(
              '유니온 추천',
              style: TextStyle(
                fontSize: widgetFontSize,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
