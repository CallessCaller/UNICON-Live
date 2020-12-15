import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/edit_profile_screen/edit_profile_page.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/unicoin_page.dart';

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
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: userDB.profile,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(
                UniIcon.profile,
                size: 45,
              ),
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
                  radius: 45,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        userDB.isArtist
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: appKeyColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                ],
                              )
                            : SizedBox(),
                        Expanded(
                          child: Text(
                            userDB.name,
                            overflow: TextOverflow.ellipsis,
                            style: title3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Text(
                            userDB.email ?? 'no email',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: outlineColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 7),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: outlineColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      UniIcon.unicoin,
                      size: 30,
                      color: appKeyColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      userDB.points.toString(),
                      style: body2,
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyUnicoinPage(
                      userDB: userDB,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        SizedBox(
          height: 25,
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(widgetRadius),
            side: BorderSide(
              color: outlineColor,
              width: 1,
            ),
          ),
          color: Colors.transparent,
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
            '프로필 편집',
            style: body1,
          ),
        ),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}
