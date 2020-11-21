import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

class WalkthroughSlide extends StatelessWidget {
  final String text, image, title;

  const WalkthroughSlide({Key key, this.text, this.image, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: outlineColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.asset(image),
            borderRadius: BorderRadius.circular(20),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: appKeyColor,
              fontSize: 60,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
