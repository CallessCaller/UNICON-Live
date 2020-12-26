import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_initial_genre_selection.dart';

class WaitForAuth extends StatefulWidget {
  @override
  _WaitForAuthState createState() => _WaitForAuthState();
}

class _WaitForAuthState extends State<WaitForAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: 80,
              right: 80,
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        '감사합니다!',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Center(
                      child: Text(
                        '유니온 신청이 등록되었습니다.\n확인 후 승인 완료됩니다.',
                        textAlign: TextAlign.center,
                        style: body4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width - 60,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: appKeyColor,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InitialGenreSelection(),
                    ),
                  );
                },
                child: Text(
                  '시작하기',
                  style: subtitle1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
