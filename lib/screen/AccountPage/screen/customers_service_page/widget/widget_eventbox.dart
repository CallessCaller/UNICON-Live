import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

class EventBox extends StatelessWidget {
  final String name;
  // final String imageUrl;

  const EventBox({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widgetRadius),
            child: Container(
              height: 180,
              width: 335,
              child: Image.asset(
                "assets/banner_string.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
