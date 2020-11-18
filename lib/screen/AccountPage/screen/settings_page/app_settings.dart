import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/settings_page/screen/app_information.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class AppSettingsPage extends StatefulWidget {
  final UserDB userDB;
  AppSettingsPage({this.userDB});
  @override
  _AppSettingsPageState createState() => _AppSettingsPageState();
}

// 환경설정으로 앱 내 설정 바꿔야 함
class _AppSettingsPageState extends State<AppSettingsPage> {
  SharedPreferences _preferences;
  // 전체
  bool _all = true;
  // 라이브
  bool _live = true;
  // 새 게시물
  bool _feed = true;

  @override
  void initState() {
    _loadFirst();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _saveFirst();
  }

  void _saveFirst() async {
    _preferences = await SharedPreferences.getInstance();

    _preferences.setBool('_all', _all);
    _preferences.setBool('_live', _live);
    _preferences.setBool('_feed', _feed);
  }

  void _loadFirst() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      // SharedPreferences에 counter로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _all = (_preferences.getBool('_all') ?? true);
      _live = (_preferences.getBool('_live') ?? true);
      _feed = (_preferences.getBool('_feed') ?? true);
    });
  }

  void _onChanged0(bool value) {
    if (value) {
      widget.userDB.follow.forEach((element) async {
        await _firebaseMessaging.subscribeToTopic(element + 'live');
        await _firebaseMessaging.subscribeToTopic(element + 'Feed');
      });
    } else {
      widget.userDB.follow.forEach((element) async {
        await _firebaseMessaging.unsubscribeFromTopic(element + 'live');
        await _firebaseMessaging.unsubscribeFromTopic(element + 'Feed');
      });
    }
    setState(() {
      _all = value;
      _live = value;
      _feed = value;
    });
  }

  void _onChanged4(bool value) async {
    if (value) {
      widget.userDB.follow.forEach((element) async {
        await _firebaseMessaging.subscribeToTopic(element + 'live');
      });
    } else {
      widget.userDB.follow.forEach((element) async {
        await _firebaseMessaging.unsubscribeFromTopic(element + 'live');
      });
    }
    setState(() {
      if (value == false) {
        _all = false;
      } else if (_feed == true && value == true) {
        _all = true;
      }
      _live = value;
    });
  }

  void _onChanged5(bool value) async {
    if (value) {
      widget.userDB.follow.forEach((element) async {
        await _firebaseMessaging.subscribeToTopic(element + 'Feed');
      });
    } else {
      widget.userDB.follow.forEach((element) async {
        await _firebaseMessaging.unsubscribeFromTopic(element + 'Feed');
      });
    }
    setState(() {
      if (value == false) {
        _all = false;
      } else if (_live == true && value == true) {
        _all = true;
      }
      _feed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '환경설정',
          style: headline2,
        ),
        centerTitle: false,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '일반',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SwitchListTile(
                value: _all,
                onChanged: _onChanged0,
                activeColor: appKeyColor,
                contentPadding: const EdgeInsets.all(0),
                title: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '전체 알림',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '마이 유니온 알림',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SwitchListTile(
                value: _live,
                onChanged: _onChanged4,
                activeColor: appKeyColor,
                contentPadding: const EdgeInsets.all(0),
                title: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '라이브 알림',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SwitchListTile(
                value: _feed,
                onChanged: _onChanged5,
                activeColor: appKeyColor,
                contentPadding: const EdgeInsets.all(0),
                title: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '새 게시물 알림',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AppInformationPage(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '앱 정보',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
