import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/customers_service_page/customers_service_page.dart';
import 'package:testing_layout/screen/AccountPage/screen/event_screen/screen_event.dart';
import 'package:testing_layout/screen/AccountPage/screen/notification_screen/screen_notification.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_account_header.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_my_fee_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_my_musicians_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_new_unions_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_settings_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_taste_icon.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userDB = Provider.of<UserDB>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Column(
                        children: [
                          AccountHeader(userDB: userDB),
                          Wrap(
                            spacing: 20.0,
                            runSpacing: 40.0,
                            alignment: WrapAlignment.start,
                            children: userDB.isArtist
                                ? [
                                    ToMyMusicians(),
                                    NewUnionsIcon(userDB: userDB),
                                    TasteIcon(userDB: userDB),
                                    MyFee(),
                                    ToAppSettings(),
                                  ]
                                : [
                                    ToMyMusicians(),
                                    NewUnionsIcon(userDB: userDB),
                                    TasteIcon(userDB: userDB),
                                    ToAppSettings(),
                                  ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      color: outlineColor,
                      height: 0,
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding, vertical: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '고객센터',
                            style: body1,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CSPage(userDB: userDB),
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: outlineColor,
                      height: 0,
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding, vertical: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '공지사항',
                            style: body1,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: outlineColor,
                      height: 0,
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding, vertical: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '이벤트',
                            style: body1,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: outlineColor,
                      height: 0,
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
