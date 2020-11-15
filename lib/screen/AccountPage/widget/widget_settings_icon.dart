import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/settings_page/app_settings.dart';

class ToAppSettings extends StatelessWidget {
  const ToAppSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserDB userDB = Provider.of<UserDB>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AppSettingsPage(userDB: userDB),
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
              UniIcon.settings,
              size: 35,
            ),
            SizedBox(height: 10),
            Text(
              '환경설정',
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
