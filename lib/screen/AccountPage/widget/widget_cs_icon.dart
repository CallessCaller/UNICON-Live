import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/customers_service_page/customers_service_page.dart';

class CSIcon extends StatelessWidget {
  final UserDB userDB;

  const CSIcon({this.userDB});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CSPage(userDB: userDB),
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
              UniIcon.customer_service,
              size: 35,
            ),
            SizedBox(height: 10),
            Text(
              '고객센터',
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
