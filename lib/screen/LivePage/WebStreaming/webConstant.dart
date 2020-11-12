import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

bool hideChat = true;
bool goDown = false;

double maxheight;
double maxwidth;

List<Widget> chitchat = [
  //실시간으로 받아서 업데이트
  //현 시점으로부터 최대 100개씩만
  //업데이트되면 bottom으로 스크롤
];

Widget nameText(
  String name,
  String content,
  bool gift,
) {
  double _width = maxwidth;
  Text nameField = Text(
    gift ? '' : name + ' : ',
    style: TextStyle(
        fontSize: textFontSize - 2,
        color: Colors.black,
        fontWeight: FontWeight.w600),
  );

  Text contentField = Text(
    content,
    style: TextStyle(
        fontSize: textFontSize - 1,
        color: gift
            ? appKeyColor.withOpacity(0.8)
            : Colors.black.withOpacity(0.8)),
  );

  Container tmp = Container(
    width: _width,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      children: [
        nameField,
        new Expanded(
          child: contentField,
        )
      ],
    ),
  );

  return tmp;
}
