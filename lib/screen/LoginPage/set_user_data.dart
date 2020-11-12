import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/initial_genre_selection.dart';
import 'package:testing_layout/widget/widget_flutter_datetime_picker.dart';
import 'package:testing_layout/widget/widget_i18n_model.dart';
import 'package:image/image.dart' as img;

class SetUserData extends StatefulWidget {
  @override
  _SetUserDataState createState() => _SetUserDataState();
}

class _SetUserDataState extends State<SetUserData> {
  File _image;
  bool _canGo = true;

  User _user = FirebaseAuth.instance.currentUser;

  TextEditingController _nameEditingController = TextEditingController();

  DateTime _dateTime = DateTime.now();
  String _profileImageURL = FirebaseAuth.instance.currentUser.photoURL;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _nameEditingController.text = _user.displayName;
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
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _canGo = false;
                });
                _uploadImageToStorage(ImageSource.gallery);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
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
            // user name
            Container(
              height: 30,
              width: 157,
              child: Center(
                child: TextField(
                  controller: _nameEditingController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '이름(실명)',
                    hintStyle: TextStyle(
                      fontSize: textFontSize,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 0,
              width: 157,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: .5,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // birthday edit
            InkWell(
              onTap: _showDateTimePicker,
              child: Container(
                height: 30,
                width: 157,
                child: Center(
                  child: Text(
                    '${_dateTime.year}년 ${_dateTime.month}월 ${_dateTime.day}일',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 0,
              width: 157,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: .5,
                ),
              ),
            ),
            SizedBox(
              height: 90,
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: 157,
                child: RaisedButton(
                  disabledColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  onPressed: _canGo
                      ? () async {
                          if (_nameEditingController.text != '') {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(_user.uid)
                                .update(
                              {
                                'name': _nameEditingController.text,
                                'birth': _dateTime,
                                'profile': _profileImageURL
                              },
                            );
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InitialGenreSelection(),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    '시작하기!',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
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
