import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/edit_profile_screen/widget/widget_union_genre_edit.dart';
import 'package:testing_layout/screen/AccountPage/screen/edit_profile_screen/widget/widget_union_mood_edit.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/screen_artist_format.dart';
import 'package:testing_layout/screen/LoginPage/login_page.dart';
import 'package:testing_layout/widget/widget_flutter_datetime_picker.dart';
import 'package:testing_layout/widget/widget_i18n_model.dart';
import 'package:image/image.dart' as img;

class EditProfilePage extends StatefulWidget {
  final UserDB userDB;

  const EditProfilePage({Key key, this.userDB}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File _image;
  bool _canGo = true;
  String _dropDownEmailDomain;

  final List<String> emails = [
    "gmail.com",
    "naver.com",
    "daum.net",
    "nate.com",
    "kakao.com",
  ];

  DateTime _dateTime;
  String _profileImageURL;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _instagramEditingController = TextEditingController();
  TextEditingController _youtubeEditingController = TextEditingController();
  TextEditingController _soundcloudEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileImageURL = widget.userDB.profile;
    _dateTime = widget.userDB.birth.toDate();
    _nameEditingController = TextEditingController(text: widget.userDB.name);
    _emailEditingController =
        TextEditingController(text: widget.userDB.email.split('@')[0]);
    _dropDownEmailDomain = emails[0];

    if (widget.userDB.isArtist) {
      _instagramEditingController =
          TextEditingController(text: widget.userDB.instagramId);
      _youtubeEditingController =
          TextEditingController(text: widget.userDB.youtubeLink);
      _soundcloudEditingController =
          TextEditingController(text: widget.userDB.soudcloudLink);
    }
  }

  void _showDateTimePicker() {
    DatePicker.showDatePicker(
      context,
      minTime: DateTime(1970, 1, 1),
      maxTime: DateTime.now(),
      currentTime: _dateTime,
      locale: LocaleType.ko,
      onConfirm: (dateTime) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '프로필 수정',
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            FlatButton(
              onPressed: _canGo
                  ? () async {
                      if (_nameEditingController.text != '') {
                        if (_emailEditingController.text != '') {
                          Map<String, dynamic> _userUploadResult = {
                            'name': _nameEditingController.text.trim(),
                            'email': _emailEditingController.text.trim() +
                                '@' +
                                _dropDownEmailDomain,
                            'birth': _dateTime,
                            'profile': _profileImageURL,
                          };

                          if (widget.userDB.isArtist) {
                            if (_soundcloudEditingController.text != '' ||
                                _youtubeEditingController.text != '' ||
                                _instagramEditingController.text != '') {
                              bool check1 = false;
                              bool check2 = false;
                              bool check3 = false;
                              if (_soundcloudEditingController.text != '') {
                                if (_soundcloudEditingController.text
                                    .contains('soundcloud.com')) {
                                  if (_soundcloudEditingController.text
                                      .startsWith('https://')) {
                                    _userUploadResult['soundcloud_link'] =
                                        _soundcloudEditingController.text
                                            .trim();
                                  } else {
                                    _userUploadResult['soundcloud_link'] =
                                        'https://' +
                                            _soundcloudEditingController.text
                                                .trim();
                                  }
                                  check1 = true;
                                } else {
                                  var _alertDialog = AlertDialog(
                                    title: Text(
                                      "사운드클라우드 링크를 정확하게 입력하세요.",
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _alertDialog,
                                  );
                                  check1 = false;
                                }
                              }

                              if (_youtubeEditingController.text != '') {
                                if (_youtubeEditingController.text
                                    .contains('youtube.com')) {
                                  if (_soundcloudEditingController.text
                                      .startsWith('https://')) {
                                    _userUploadResult['youtube_link'] =
                                        _youtubeEditingController.text.trim();
                                  } else {
                                    _userUploadResult['youtube_link'] =
                                        'https://' +
                                            _youtubeEditingController.text
                                                .trim();
                                  }

                                  check2 = true;
                                } else {
                                  var _alertDialog = AlertDialog(
                                    title: Text(
                                      "유튜브 링크를 정확하게 입력하세요.",
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _alertDialog,
                                  );
                                  check2 = false;
                                }
                              }

                              if (_instagramEditingController.text != '') {
                                _userUploadResult['instagram_id'] =
                                    _instagramEditingController.text
                                        .trim()
                                        .replaceAll('@', '');
                                check3 = true;
                              }

                              if (check1 || check2 || check3) {
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(widget.userDB.id)
                                    .update(_userUploadResult);
                                Navigator.of(context).pop();
                              }
                            } else {
                              var _alertDialog = AlertDialog(
                                title: Text(
                                  "링크를 적어도 하나 입력하세요.",
                                  style: TextStyle(
                                    fontSize: textFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _alertDialog,
                              );
                            }
                          } else {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(widget.userDB.id)
                                .update(_userUploadResult);
                            Navigator.of(context).pop();
                          }
                        } else {
                          var _alertDialog = AlertDialog(
                            title: Text(
                              "이메일 주소를 입력하세요.",
                              style: TextStyle(
                                fontSize: textFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _alertDialog,
                          );
                        }
                      } else {
                        var _alertDialog = AlertDialog(
                          title: Text(
                            "이름이 누락되었습니다.",
                            style: TextStyle(
                              fontSize: textFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _alertDialog,
                        );
                      }
                    }
                  : null,
              child: Text(
                '완료',
                style: TextStyle(
                  color: appKeyColor,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.userDB.isArtist
                    ? <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _canGo = false;
                              });
                              _uploadImageToStorage(ImageSource.gallery);
                            },
                            child: CachedNetworkImage(
                              imageUrl: _profileImageURL,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: appKeyColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 80,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  UniIcon.account_box,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 128,
                                  height: 30,
                                  child: TextFormField(
                                    autocorrect: false,
                                    textInputAction: TextInputAction.next,
                                    controller: _nameEditingController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "이름 (Required)",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: appKeyColor,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  UniIcon.calendar,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: _showDateTimePicker,
                                  child: Container(
                                    width: 128,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        '${_dateTime.year}.${_dateTime.month}.${_dateTime.day}',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 128,
                                  height: 30,
                                  child: TextFormField(
                                    controller: _emailEditingController,
                                    maxLines: 1,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.next,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "이메일 (Required)",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: appKeyColor,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 17,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '@',
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 30,
                                  width: 128,
                                  child: Center(
                                    child: DropdownButton<String>(
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      isDense: true,
                                      value: _dropDownEmailDomain,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 20,
                                      underline: Container(
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _dropDownEmailDomain = newValue;
                                        });
                                      },
                                      items: emails
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: textFontSize),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 30,
                          child: TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.url,
                            controller: _soundcloudEditingController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: textFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Soundcloud link",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: appKeyColor,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              icon: Icon(
                                UniIcon.soundcloud,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 30,
                          child: TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.url,
                            controller: _youtubeEditingController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: textFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Youtube link",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: appKeyColor,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              icon: Icon(
                                UniIcon.youtube,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 30,
                          child: TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            controller: _instagramEditingController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: textFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Instagram ID",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: appKeyColor,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              icon: Icon(
                                UniIcon.instagram,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              color: appKeyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widgetRadius),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UnionGenreEdit(userDB: widget.userDB),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Text(
                                '장르 수정하기',
                                style: TextStyle(
                                  fontSize: textFontSize,
                                ),
                              ),
                            ),
                            FlatButton(
                              color: appKeyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widgetRadius),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UnionMoodEdit(userDB: widget.userDB),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Text(
                                '무드 수정하기',
                                style: TextStyle(
                                  fontSize: textFontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ]
                    : [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _canGo = false;
                              });
                              _uploadImageToStorage(ImageSource.gallery);
                            },
                            child: CachedNetworkImage(
                              imageUrl: _profileImageURL,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: appKeyColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 80,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  UniIcon.account_box,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 128,
                                  height: 30,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _nameEditingController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "이름 (Required)",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: appKeyColor,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  UniIcon.calendar,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: _showDateTimePicker,
                                  child: Container(
                                    width: 128,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        '${_dateTime.year}.${_dateTime.month}.${_dateTime.day}',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 128,
                                  height: 30,
                                  child: TextFormField(
                                    controller: _emailEditingController,
                                    maxLines: 1,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.next,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "이메일 (Required)",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: appKeyColor,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 17,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '@',
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 30,
                                  width: 128,
                                  child: Center(
                                    child: DropdownButton<String>(
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      isDense: true,
                                      value: _dropDownEmailDomain,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 20,
                                      underline: Container(
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _dropDownEmailDomain = newValue;
                                        });
                                      },
                                      items: emails
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: textFontSize),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 210,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ArtistForm(),
                                ),
                              );
                            },
                            child: Container(
                              width: 157,
                              height: 30,
                              decoration: BoxDecoration(
                                color: appKeyColor,
                                borderRadius:
                                    BorderRadius.circular(widgetRadius),
                              ),
                              child: Center(
                                child: Text(
                                  '유니온 도전하기!',
                                  style: TextStyle(
                                    fontSize: textFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
              ),
              Positioned(
                bottom: 0,
                left: 1,
                right: 1,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            title: Text('Sign out'),
                            content: Text('로그아웃 하시겠습니까?'),
                            actions: [
                              TextButton(
                                child: Text(
                                  'Sign out',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: textFontSize,
                                  ),
                                ),
                                onPressed: () async {
                                  if (widget.userDB.id.contains('kakao')) {
                                    await kakaoSignOut(context);
                                  } else {
                                    signOutGoogle(context);
                                  }
                                },
                              ),
                              TextButton(
                                child: Text(
                                  '취소',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: textFontSize,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Sign out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _uploadImageToStorage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedImage = await imagePicker.getImage(source: source);

    if (pickedImage == null) {
      setState(() {
        // _profileImageURL = _user.photoURL;
        _canGo = true;
      });
    } else {
      img.Image imageTmp =
          img.decodeImage(File(pickedImage.path).readAsBytesSync());
      img.Image resizedImg = img.copyResize(
        imageTmp,
        height: 1000,
      );

      File resizedFile = File(pickedImage.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImg));
      setState(() {
        _image = resizedFile;
      });

      // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
      Reference storageReference =
          _firebaseStorage.ref().child("profile/${widget.userDB.id}");

      // 파일 업로드
      // 파일 업로드 완료까지 대기
      await storageReference.putFile(_image);

      // 업로드한 사진의 URL 획득
      String downloadURL = await storageReference.getDownloadURL();

      // 업로드된 사진의 URL을 페이지에 반영
      setState(() {
        _profileImageURL = downloadURL;
        _canGo = true;
      });
    }
  }
}
