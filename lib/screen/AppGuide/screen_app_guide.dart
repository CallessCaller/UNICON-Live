import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/login_page.dart';

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

  void _saveFirst() async {
    _preferences = await SharedPreferences.getInstance();

    _preferences.setBool('first', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     _saveFirst();
                  //     Navigator.of(context).pushReplacement(
                  //         MaterialPageRoute(builder: (context) => LoginPage()));
                  //   },
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width * 0.3,
                  //     decoration: BoxDecoration(
                  //         // border: Border(
                  //         //   bottom: BorderSide(color: outlineColor, width: 1),
                  //         // ),
                  //         ),
                  //     child: Text(
                  //       '건너뛰기',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w500,
                  //         color: outlineColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: currentPage != 3
                            ? Colors.transparent
                            : Colors.white,
                      ),
                      onPressed: () {
                        if (currentPage == 3) {
                          _saveFirst();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } else {
                          controller.nextPage();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.87,
              width: MediaQuery.of(context).size.width,
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
                  onScrolled: (value) {
                    // if (value > 3.0) {
                    //   Navigator.of(context).pushNamedAndRemoveUntil(
                    //       '/login', (Route<dynamic> route) => false);
                    // }
                  },
                ),
              ),
            ),

            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         _saveFirst();
            //         Navigator.of(context).pushReplacement(r
            //             MaterialPageRoute(
            //                 builder: (context) => LoginPage()));
            //       },
            //       child: Container(
            //         decoration: BoxDecoration(
            //           border: Border(
            //             bottom:
            //                 BorderSide(color: outlineColor, width: 1),
            //           ),
            //         ),
            //         child: Text(
            //           '건너뛰기',
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //             color: outlineColor,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: List.generate(
            //         guideImages.length,
            //         (index) => buildDot(index: index),
            //       ),
            //     ),
            //     FlatButton(
            //       materialTapTargetSize:
            //           MaterialTapTargetSize.shrinkWrap,
            //       color: appKeyColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(14),
            //       ),
            //       child: Icon(
            //         Icons.arrow_forward_ios_rounded,
            //         color: Colors.white,
            //       ),
            //       height: 59,
            //       minWidth: 69,
            //       onPressed: () {
            //         if (currentPage == 2) {
            //           _saveFirst();
            //           Navigator.of(context).pushReplacement(
            //               MaterialPageRoute(
            //                   builder: (context) => LoginPage()));
            //         } else {
            //           changePageViewPostion(currentPage);
            //         }
            //       },
            //     )
            //   ],
            // )
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
