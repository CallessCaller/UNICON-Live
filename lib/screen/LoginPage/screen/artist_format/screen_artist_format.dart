import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/screen/union_genre_select.dart';
import 'package:image/image.dart' as img;

class ArtistForm extends StatefulWidget {
  @override
  _ArtistFormState createState() => _ArtistFormState();
}

class _ArtistFormState extends State<ArtistForm> {
  File _image;
  bool _canGo = true;

  User _user = FirebaseAuth.instance.currentUser;
  String _profileImageURL;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _instagramEditingController = TextEditingController();
  TextEditingController _youtubeEditingController = TextEditingController();
  TextEditingController _soundcloudEditingController = TextEditingController();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FToast fToast;

  @override
  void initState() {
    super.initState();
    _profileImageURL = _user.photoURL == null
        ? 'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/unnamed.png?alt=media&token=5b656cb4-055c-4734-a93b-b3c9c629fc5a'
        : _user.photoURL;
    _nameEditingController = TextEditingController(text: '');

    fToast = FToast();
    fToast.init(context);
    _instagramEditingController = TextEditingController(text: '');
    _youtubeEditingController = TextEditingController(text: '');
    _soundcloudEditingController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          '뮤지션 정보 등록',
          style: headline2,
        ),
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
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: appKeyColor,
                                width: 1.5,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(_profileImageURL),
                              radius: 80,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  UniIcon.fix,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _canGo = false;
                                });
                                _uploadImageToStorage(ImageSource.gallery);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          UniIcon.profile,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            controller: _nameEditingController,
                            style: body2,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "활동명 (필수)",
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
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          UniIcon.soundcloud,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.url,
                            controller: _soundcloudEditingController,
                            style: body2,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          UniIcon.youtube,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.url,
                            controller: _youtubeEditingController,
                            style: body2,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          UniIcon.instagram,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            controller: _instagramEditingController,
                            keyboardType: TextInputType.text,
                            style: body2,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width - 60,
                height: 50,
                color: appKeyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onPressed: _canGo
                    ? () async {
                        if (_nameEditingController.text != '') {
                          Map<String, dynamic> _userUploadResult = {
                            'name': _nameEditingController.text.trim(),
                          };
                          Map<String, dynamic> _pendingUploadResult = {
                            'name': _nameEditingController.text.trim(),
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
                                    .trim()
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
                                Widget toast = Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: dialogColor1,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.warning),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(
                                        "사운드클라우드 링크를 정확하게 입력하세요.",
                                        style: caption2,
                                      ),
                                    ],
                                  ),
                                );

                                fToast.showToast(
                                  child: toast,
                                  gravity: ToastGravity.CENTER,
                                  toastDuration: Duration(seconds: 2),
                                );
                                check1 = false;
                              }
                            }

                            if (_youtubeEditingController.text != '') {
                              if (_youtubeEditingController.text
                                  .contains('youtube.com')) {
                                _userUploadResult['youtube_link'] =
                                    _youtubeEditingController.text.trim();
                                _pendingUploadResult['youtube_link'] =
                                    _youtubeEditingController.text.trim();

                                check2 = true;
                              } else {
                                Widget toast = Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: dialogColor1,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.warning),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(
                                        "유튜브 링크를 정확히 입력하세요.",
                                        style: caption2,
                                      ),
                                    ],
                                  ),
                                );

                                fToast.showToast(
                                  child: toast,
                                  gravity: ToastGravity.CENTER,
                                  toastDuration: Duration(seconds: 2),
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
                              _userUploadResult['profile'] = _profileImageURL;

                              // id added to pending
                              _pendingUploadResult['id'] = _user.uid;
                              _pendingUploadResult['profile'] =
                                  _profileImageURL;

                              if (_user.email == null ||
                                  _user.email.contains('appleid.com') ||
                                  _user.email == "") {
                                await showEmailAlert(context, _userUploadResult,
                                    _pendingUploadResult, _user);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => UnionGenreSelection(),
                                  ),
                                );
                              } else {
                                _userUploadResult['email'] = _user.email;
                                _pendingUploadResult['email'] = _user.email;
                                await uploadPending(context, _userUploadResult,
                                    _pendingUploadResult, _user);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => UnionGenreSelection(),
                                  ),
                                );
                              }
                              // await showEmailAlert(context, _userUploadResult,
                              //     _pendingUploadResult, _user);
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => UnionGenreSelection(),
                              //   ),
                              // );
                            }
                          } else {
                            Widget toast = Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 12.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: dialogColor1,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.warning),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    "SNS를 적어도 하나 입력하세요.",
                                    style: caption2,
                                  ),
                                ],
                              ),
                            );

                            fToast.showToast(
                              child: toast,
                              gravity: ToastGravity.CENTER,
                              toastDuration: Duration(seconds: 2),
                            );
                          }
                        } else {
                          Widget toast = Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: dialogColor1,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text(
                                  "이름이 누락되었습니다.",
                                  style: caption2,
                                ),
                              ],
                            ),
                          );

                          fToast.showToast(
                            child: toast,
                            gravity: ToastGravity.CENTER,
                            toastDuration: Duration(seconds: 2),
                          );
                        }
                      }
                    : null,
                child: Text(
                  '저장',
                  style: subtitle1,
                ),
              ),
            ),
          ],
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

Future<void> uploadPending(
    BuildContext context,
    Map<String, dynamic> userUploadResult,
    Map<String, dynamic> pendingUploadResult,
    User user) async {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .update(userUploadResult);

  await FirebaseFirestore.instance
      .collection('Pending')
      .doc(user.uid)
      .set(pendingUploadResult);

  await _firebaseMessaging.subscribeToTopic(user.uid + 'pending');
}

Future<void> showEmailAlert(
  BuildContext context,
  Map<String, dynamic> userUploadResult,
  Map<String, dynamic> pendingUploadResult,
  User user,
) async {
  TextEditingController emailController = new TextEditingController(text: '');
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.6),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "이메일을 입력해주세요.",
              style: body1,
            ),
            TextField(
              style: body4,
              controller: emailController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                contentPadding: EdgeInsets.all(0),
                hintText: 'example@example.com',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '신청',
              style: TextStyle(color: appKeyColor),
            ),
            onPressed: () async {
              userUploadResult['email'] = emailController.text;
              pendingUploadResult['email'] = emailController.text;
              await uploadPending(
                  context, userUploadResult, pendingUploadResult, user);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
