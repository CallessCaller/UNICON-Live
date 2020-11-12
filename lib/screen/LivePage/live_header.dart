import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/live_header%2Fbanner_person_listening.png?alt=media&token=c073c465-924b-437e-a9e6-f5b644bdfa4d',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/live_header%2Fbanner_string.png?alt=media&token=c5195ae5-e791-42aa-863e-20c0fce662f0',
];

class LiveHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LiveHeaderState();
  }
}

class _LiveHeaderState extends State<LiveHeader> {
  @override
  Widget build(BuildContext context) {
    List tmp = [];
    for (var i = 0; i < imgList.length; ++i) {
      tmp.add(NetworkImage(imgList[i]));
    }
    return SizedBox(
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        autoplay: true,
        autoplayDuration: Duration(milliseconds: 7000),
        images: tmp,
        dotSize: 4.0,
        dotSpacing: 15.0,
        // dotColor: Colors.black,
        dotIncreasedColor: Colors.white,
        dotBgColor: Colors.transparent,

        indicatorBgPadding: 10.0,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );
  }
}
