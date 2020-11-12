import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/artist_format_page.dart';
import 'package:testing_layout/screen/LoginPage/set_user_data.dart';

class ArtistOrUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 130,
            ),
            Container(
              height: 50,
              child: Center(
                child: Text(
                  '환영합니다!',
                  style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              height: 50,
              child: Center(
                child: Text(
                  '뮤지션이신가요?',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    height: 40,
                    minWidth: 157,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArtistForm()));
                    },
                    child: Text(
                      '네',
                      style: TextStyle(
                          fontSize: textFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                FlatButton(
                    height: 40,
                    minWidth: 157,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetUserData()));
                    },
                    child: Text(
                      '아니오',
                      style: TextStyle(
                          fontSize: textFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
