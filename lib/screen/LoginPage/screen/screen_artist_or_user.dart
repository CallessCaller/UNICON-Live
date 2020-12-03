import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/screen_artist_format.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_initial_genre_selection.dart';

class ArtistOrUser extends StatelessWidget {
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
                        '환영합니다!',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Center(
                      child: Text(
                        '뮤지션이신가요?',
                        style: title1,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: Text(
                "'네'를 선택하시면 뮤지션 등록을 위한\n추가 정보가 필요합니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appKeyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    height: 40,
                    minWidth: 130,
                    splashColor: appKeyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: outlineColor,
                        width: 2,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtistForm(),
                        ),
                      );
                    },
                    child: Text(
                      '네',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FlatButton(
                    height: 40,
                    minWidth: 130,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: outlineColor,
                        width: 2,
                      ),
                    ),
                    splashColor: appKeyColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InitialGenreSelection(),
                        ),
                      );
                    },
                    child: Text(
                      '아니오',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
