import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';

class Unicoin100 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Color(0xfffe37af),
            highlightColor: Color(0xfffe81cc),
            child: Icon(
              UniIcon.unicoin,
              size: 40,
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(
              '100',
              style: body4,
            ),
          ),
        ],
      ),
    );
  }
}
