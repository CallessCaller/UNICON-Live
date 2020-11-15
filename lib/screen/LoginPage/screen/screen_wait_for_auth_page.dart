import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/tab_page.dart';

class WaitForAuth extends StatefulWidget {
  @override
  _WaitForAuthState createState() => _WaitForAuthState();
}

class _WaitForAuthState extends State<WaitForAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),
            Container(
              height: 50,
              child: Center(
                child: Text(
                  '감사합니다!',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              child: Center(
                child: Text(
                  '유니온 신청이 등록되었습니다.\n확인 후 승인 완료됩니다.',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widgetRadius),
              ),
              elevation: 0,
              color: appKeyColor,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabPage(),
                  ),
                );
              },
              child: Container(
                width: 157,
                height: 30,
                child: Center(
                  child: Text(
                    '시작하기',
                    style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
