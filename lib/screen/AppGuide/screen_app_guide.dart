import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/artist_login_page.dart';
import 'package:testing_layout/screen/LoginPage/widget/apple_sign_button.dart';
import 'package:testing_layout/screen/LoginPage/widget/google_sign_button.dart';
import 'package:testing_layout/screen/LoginPage/widget/kakao_sign_button.dart';

class AppGuideScreen extends StatefulWidget {
  @override
  _AppGuideScreenState createState() => _AppGuideScreenState();
}

class _AppGuideScreenState extends State<AppGuideScreen> {
  int currentPage = 0;
  CarouselController controller = CarouselController();
  SharedPreferences _preferences;
  List<Widget> _guideImages;

  @override
  void initState() {
    super.initState();
    List<String> guideImages;
    if (Platform.isIOS) {
      guideImages = iosGuideImage;
    } else {
      guideImages = aosGuideImage;
    }
    _guideImages = guideImages.map((m) => Image.asset(m)).toList();
  }

  void changePageViewPostion(int whichPage) {
    if (controller != null) {
      // print(whichPage);
      whichPage = whichPage + 1; // because position will start from 0
      controller.animateToPage(whichPage,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  // ignore: unused_element
  void _saveFirst() async {
    _preferences = await SharedPreferences.getInstance();

    _preferences.setBool('first', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buildDot(
                              length: _guideImages.length, index: currentPage),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.transparent),
                          onPressed: null,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height * 0.87,
                  // width: MediaQuery.of(context).size.width,
                  //color: Colors.blue,
                  alignment: Alignment.topCenter,
                  child: CarouselSlider(
                    carouselController: controller,
                    items: _guideImages,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: MediaQuery.of(context).size.height * 0.87,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, r) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      onScrolled: (value) {},
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                width: MediaQuery.of(context).size.width,
                height: currentPage == 3
                    ? MediaQuery.of(context).size.height * 0.35 <= 294
                        ? 294
                        : MediaQuery.of(context).size.height * 0.35
                    : 0,
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  children: [
                    // Divider(
                    //   color: Colors.white,
                    //   height: 20,
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Sign in with',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: Platform.isIOS
                          ? [
                              AppleSignButton(
                                isArtist: false,
                              ),
                              GoogleSignButton(
                                isArtist: false,
                              ),
                              KakaoSignButton(
                                isArtist: false,
                              )
                            ]
                          : [
                              GoogleSignButton(
                                isArtist: false,
                              ),
                              KakaoSignButton(
                                isArtist: false,
                              )
                            ],
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Text(
                      '당신이 뮤지션이라면?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      height: 55,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11.0),
                      ),
                      color: Color(0xff3E3E3E),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArtistLoginPage()));
                      },
                      child: Text(
                        '뮤지션 등록/신청',
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildDot({int length, int index}) {
    List<Widget> results = [];
    for (var i = 0; i < length; i++) {
      results.add(AnimatedContainer(
        width: 10,
        height: 10,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == i ? appKeyColor : Colors.grey,
        ),
        duration: Duration(milliseconds: 300),
      ));
    }

    return results;
  }
}
