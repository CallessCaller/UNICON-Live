import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/size_config.dart';
import 'package:testing_layout/screen/AppGuide/widget/widget_walkthroughslide.dart';

class AppGuideScreen extends StatefulWidget {
  @override
  _AppGuideScreenState createState() => _AppGuideScreenState();
}

class _AppGuideScreenState extends State<AppGuideScreen> {
  int currentPage = 0;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPage = controller.page.toInt();
      });
    });
  }

  void changePageViewPostion(int whichPage) {
    if (controller != null) {
      whichPage = whichPage + 1; // because position will start from 0
      double jumpPosition = MediaQuery.of(context).size.width / 2;
      double orgPosition = MediaQuery.of(context).size.width / 2;
      for (int i = 0; i < walkthroughList.length; i++) {
        controller.jumpTo(jumpPosition);
        if (i == whichPage) {
          break;
        }
        jumpPosition = jumpPosition + orgPosition;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: walkthroughList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WalkthroughSlide(
                      image: walkthroughList[index]['image'],
                      text: walkthroughList[index]['text'],
                      title: walkthroughList[index]['title'],
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                left: 30,
                right: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        walkthroughList.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: outlineColor, width: 1),
                              ),
                            ),
                            child: Text(
                              '건너뛰기',
                              style: TextStyle(
                                fontSize: getProportionalScreenHeight(16),
                                fontWeight: FontWeight.w500,
                                color: outlineColor,
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          color: appKeyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                          height: 59,
                          minWidth: 69,
                          onPressed: () {
                            changePageViewPostion(currentPage);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.only(right: 5),
      height: 12,
      width: currentPage == index ? 20 : 12,
      decoration: BoxDecoration(
        color: currentPage == index ? appKeyColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
