import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/live_header%2F%EB%B0%B0%EB%84%88_new_02.png?alt=media&token=2eaa607a-dcb4-4aa7-87b3-11a8dcbd0dda',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/live_header%2F%EB%B0%B0%EB%84%88_new_01.png?alt=media&token=80956098-ceaa-44f7-9908-168d8b57755b',
];

class LiveHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LiveHeaderState();
  }
}

// Banner collection에서 불러와야 함
class _LiveHeaderState extends State<LiveHeader>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        onImageTap: (int index) {
          print(index);
        },
        autoplay: true,
        animationCurve: Curves.easeInOut,
        autoplayDuration: Duration(seconds: 3),
        images: imgList.map((e) => NetworkImage(e)).toList(),
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotIncreasedColor: Colors.white,
        dotBgColor: Colors.transparent,
        indicatorBgPadding: 10.0,
        animationDuration: Duration(milliseconds: 300),
        boxFit: BoxFit.fitWidth,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
