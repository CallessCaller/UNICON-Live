import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/edit_profile_screen/edit_profile_page.dart';

class AccountHeader extends StatelessWidget {
  final UserDB userDB;
  const AccountHeader({Key key, this.userDB}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 25.0,
        ),
        CachedNetworkImage(
          imageUrl: userDB.profile,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: userDB.isArtist ? appKeyColor : Colors.white,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: imageProvider,
              radius: 55,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Column(
          children: [
            Container(
              width: 157,
              height: 30,
              child: Center(
                child: Text(
                  userDB.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: subtitleFontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(widgetRadius),
          ),
          color: appKeyColor,
          height: 30,
          minWidth: MediaQuery.of(context).size.width - defaultPadding * 2,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProfilePage(
                  userDB: userDB,
                ),
              ),
            );
          },
          child: Text(
            '프로필 수정',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: textFontSize,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}
