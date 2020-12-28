import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/widget/apple_sign_button.dart';
import 'package:testing_layout/screen/LoginPage/widget/google_sign_button.dart';
import 'package:testing_layout/screen/LoginPage/widget/kakao_sign_button.dart';

class ArtistLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              Platform.isIOS
                  ? 'assets/walkthrough/intro_ios.png'
                  : 'assets/walkthrough/intro_aos.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffA3A3A3)),
                  borderRadius: BorderRadius.circular(22)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                              isArtist: true,
                            ),
                            GoogleSignButton(
                              isArtist: true,
                            ),
                            KakaoSignButton(
                              isArtist: true,
                            )
                          ]
                        : [
                            GoogleSignButton(
                              isArtist: true,
                            ),
                            KakaoSignButton(
                              isArtist: true,
                            )
                          ],
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    '뮤지션 전용 로그인 페이지 입니다.\n\n로그인 하시면 뮤지션 등록을 위한\n추가 정보가 필요합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appKeyColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
