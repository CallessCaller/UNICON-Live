import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_account_header.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_cs_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_myFee_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_my_musicians_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_new_unions_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_settings_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_taste_icon.dart';
import 'package:testing_layout/screen/AccountPage/widget/widget_unicoin_icon.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userDB = Provider.of<UserDB>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              AccountHeader(userDB: userDB),
              Wrap(
                spacing: 20.0,
                runSpacing: 40.0,
                alignment: WrapAlignment.start,
                children: [
                  ToMyUnicoinHistory(),
                  ToMyMusicians(),
                  NewUnionsIcon(userDB: userDB),
                  TasteIcon(userDB: userDB),
                  CSIcon(userDB: userDB),
                  ToAppSettings(),
                  userDB.isArtist ? MyFee() : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
