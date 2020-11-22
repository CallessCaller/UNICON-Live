import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_policy/screen_show-text-file.dart';

class AppInformationPage extends StatefulWidget {
  @override
  _AppInformationPageState createState() => _AppInformationPageState();
}

class _AppInformationPageState extends State<AppInformationPage> {
  String appName = "";
  String appID = "";
  String version = "";
  String buildNumber = "";

  int _counter = 0;

  void _incrementCounter(BuildContext context) {
    // 열번 찍어서 안넘어가는 여자 없다더라~
    if (_counter > 8) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dialogRadius),
            ),
            backgroundColor: dialogColor1,
            title: Center(
              child: Text(
                '회원탈퇴',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '회원탈퇴를 진행하시면 더이상 정보를 복구할 수 없게 됩니다. 이후 본인에게 발생하는 불이익은 서비스 이용약관에 따라 당사가 책임지지 않습니다. 계속해서 진행하시겠습니까?',
                  style: body3,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FlatButton(
                        color: dialogColor3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widgetRadius),
                        ),
                        onPressed: () {
                          // TODO
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '탈퇴',
                          style: TextStyle(
                            color: dialogColor4,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: FlatButton(
                        color: appKeyColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widgetRadius),
                        ),
                        onPressed: () {
                          setState(() {
                            _counter = 0;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '취소',
                          style: subtitle3,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    }
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    getAppInfo();
  }

  void getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      appID = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '앱 정보',
          style: headline2,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '버전',
                            style: subtitle1,
                          ),
                        ),
                        Text(
                          version,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowTextFileScreen(
                            filename: 'terms-and-conditions.txt',
                            title: '서비스 이용약관',
                          ),
                        ));
                      },
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '서비스 이용약관',
                            style: subtitle1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowTextFileScreen(
                            filename: 'community-guideline.txt',
                            title: '커뮤니티 가이드라인',
                          ),
                        ));
                      },
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '커뮤니티 가이드라인',
                            style: subtitle1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowTextFileScreen(
                            filename: 'privacy-policy.txt',
                            title: '개인정보 처리방침',
                          ),
                        ));
                      },
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '개인정보 처리방침',
                            style: subtitle1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowTextFileScreen(
                            filename: 'open-source-license.txt',
                            title: '오픈소스 라이선스',
                          ),
                        ));
                      },
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '오픈소스 라이선스',
                            style: subtitle1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShowTextFileScreen(
                              filename: 'legal-notice.txt',
                              title: '법적고지',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '법적고지',
                            style: subtitle1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowTextFileScreen(
                            filename: 'company-information.txt',
                            title: '사업자 정보',
                          ),
                        ));
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '사업자 정보',
                          style: subtitle1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 1,
              right: 1,
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        _incrementCounter(context);
                      },
                      child: Container(
                        height: 70,
                        child: Image.asset(
                          'assets/slogan_01.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      height: 40,
                      child: Text(
                        "© 2020. Y&W Seoul Promotion Inc.\nall rights reserved.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: textFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
