import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/widget/live_box.dart';

List<Widget> hotLive(BuildContext context, List<Artist> artists,
    List<Lives> lives, UserDB userDB) {
  List<Widget> result = [];
  lives.sort((a, b) => b.viewers.length.compareTo(a.viewers.length));
  for (int i = 0; i < lives.length; i++) {
    if (result.length == 10) break;

    int index = artists.indexWhere((artist) => artist.id.contains(lives[i].id));
    result.add(slider(context, artists[index], lives[i], userDB));
  }
  if (result.length == 0) {
    result.add(Center(
      child: Text('현재 라이브가 없습니다.'),
    ));
  }
  return result;
}

Widget slider(BuildContext context, Artist artist, Lives live, UserDB userDB) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
    child: InkWell(
      onTap: () {
        if (artist.fee == null ||
            artist.fee == 0 ||
            (live.payList != null && live.payList.contains(userDB.id))) {
          notShowAlert(context, userDB, artist, live);
        } else {
          showAlertDialog(context, userDB, artist, live);
        }
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          child: Stack(
            children: <Widget>[
              Image.network(
                artist.profile,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(8)),
                      color: Colors.black.withOpacity(0.3)),
                  child: Text(
                    artist.name +
                        ' - ' +
                        live.viewers.length.toString() +
                        '명 시청중',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widgetFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
