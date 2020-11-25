import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';

class Unicoin500 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Column(
        children: [
          Icon(
            UniIcon.unicoin,
            color: Colors.yellowAccent[400],
            size: 40,
          ),
          Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(
              '500',
              style: body4,
            ),
          ),
        ],
      ),
    );
  }
}
