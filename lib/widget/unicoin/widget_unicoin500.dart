import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';

class Unicoin500 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Color(0xffd21404),
            highlightColor: Color(0xffeb6c6b),
            child: Icon(
              UniIcon.unicoin,
              size: 40,
            ),
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
