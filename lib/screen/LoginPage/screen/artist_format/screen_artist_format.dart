import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/screen/union_genre_select.dart';
import 'package:testing_layout/widget/widget_flutter_datetime_picker.dart';
import 'package:testing_layout/widget/widget_i18n_model.dart';
import 'package:image/image.dart' as img;

class ArtistForm extends StatefulWidget {
  @override
  _ArtistFormState createState() => _ArtistFormState();
}

class _ArtistFormState extends State<ArtistForm> {
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
  User _user = FirebaseAuth.instance.currentUser;
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
    _profileImageURL = _user.photoURL;
    _dateTime = DateTime.now();
    _nameEditingController = TextEditingController(text: _user.displayName);
    _emailEditingController = TextEditingController(text: '');
    _dropDownEmailDomain = emails[0];

    for (var i = 0; i < emails.length; i++) {
      if (_user.email.split('@')[1].compareTo(emails[i]) == 0) {
        _emailEditingController.text = _user.email.split('@')[0];
        _dropDownEmailDomain = emails[i];
        break;
      }
    }
    _instagramEditingController = TextEditingController(text: '');
    _youtubeEditingController = TextEditingController(text: '');
    _soundcloudEditingController = TextEditingController(text: '');
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
          centerTitle: true,
          title: Text('뮤지션 정보 등록'),
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
                          };
                          Map<String, dynamic> _pendingUploadResult = {
                            'name': _nameEditingController.text.trim(),
                            'email': _emailEditingController.text.trim() +
                                '@' +
                                _dropDownEmailDomain,
                          };
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
                                      _soundcloudEditingController.text.trim();
                                  _pendingUploadResult['soundcloud_link'] =
                                      _soundcloudEditingController.text.trim();
                                } else {
                                  _userUploadResult['soundcloud_link'] =
                                      'https://' +
                                          _soundcloudEditingController.text
                                              .trim();
                                  _pendingUploadResult['soundcloud_link'] =
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
                                      fontSize: subtitleFontSize,
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
                                  _pendingUploadResult['youtube_link'] =
                                      _youtubeEditingController.text.trim();
                                } else {
                                  _userUploadResult['youtube_link'] =
                                      'https://' +
                                          _youtubeEditingController.text.trim();
                                  _pendingUploadResult['youtube_link'] =
                                      'https://' +
                                          _youtubeEditingController.text.trim();
                                }

                                check2 = true;
                              } else {
                                var _alertDialog = AlertDialog(
                                  title: Text(
                                    "유튜브 링크를 정확하게 입력하세요.",
                                    style: TextStyle(
                                      fontSize: subtitleFontSize,
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
                              _pendingUploadResult['instagram_id'] =
                                  _instagramEditingController.text
                                      .trim()
                                      .replaceAll('@', '');
                              check3 = true;
                            }

                            if (check1 || check2 || check3) {
                              // birth and profile added to user
                              _userUploadResult['birth'] = _dateTime;
                              _userUploadResult['profile'] = _profileImageURL;
                              // id added to pending
                              _pendingUploadResult['id'] = _user.uid;
                              _pendingUploadResult['profile'] =
                                  _profileImageURL;
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(_user.uid)
                                  .update(_userUploadResult);

                              await FirebaseFirestore.instance
                                  .collection('Pending')
                                  .doc(_user.uid)
                                  .set(_pendingUploadResult);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UnionGenreSelection(),
                                ),
                              );
                            }
                          } else {
                            var _alertDialog = AlertDialog(
                              title: Text(
                                "링크를 적어도 하나 입력하세요.",
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
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
                              "이메일 주소를 입력하세요.",
                              style: TextStyle(
                                fontSize: subtitleFontSize,
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
                              fontSize: subtitleFontSize,
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
                '다음',
                style: TextStyle(
                  color: appKeyColor,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
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
                children: [
                  Icon(
                    Icons.person,
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
                  Expanded(
                    child: Container(
                      width: 20,
                    ),
                  ),
                  Icon(
                    Icons.cake,
                    size: 20,
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
              SizedBox(
                height: 40,
              ),
              Row(
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
                  Expanded(
                    child: Container(
                      width: 20,
                    ),
                  ),
                  Container(
                    width: 17,
                    height: 30,
                    child: Center(child: Text('@')),
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
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
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
                    icon: Container(
                      width: 20,
                      child: Image.asset(
                        'assets/soundcloud_icon.png',
                        fit: BoxFit.fitWidth,
                      ),
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
                    icon: Container(
                      width: 20,
                      child: Image.asset(
                        'assets/youtube_icon.png',
                        fit: BoxFit.fitWidth,
                      ),
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
                    icon: Container(
                      width: 20,
                      child: Image.asset(
                        'assets/instagram_icon.png',
                        fit: BoxFit.fitWidth,
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
          _firebaseStorage.ref().child("profile/${_user.uid}");

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
