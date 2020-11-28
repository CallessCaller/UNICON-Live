import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_initial_genre_selection.dart';
import 'package:image/image.dart' as img;

class SetUserData extends StatefulWidget {
  @override
  _SetUserDataState createState() => _SetUserDataState();
}

class _SetUserDataState extends State<SetUserData> {
  File _image;
  bool _canGo = true;
  FToast fToast;
  User _user = FirebaseAuth.instance.currentUser;

  TextEditingController _nameEditingController = TextEditingController();

  String _profileImageURL = FirebaseAuth.instance.currentUser.photoURL == null
      ? 'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/unnamed.png?alt=media&token=5b656cb4-055c-4734-a93b-b3c9c629fc5a'
      : FirebaseAuth.instance.currentUser.photoURL;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _nameEditingController.text = _user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '사용자 정보 등록',
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
                  children: [
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
                                color: Colors.white,
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
                    SizedBox(height: 150),
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
                child: Text(
                  '저장',
                  style: subtitle1,
                ),
                onPressed: _canGo
                    ? () async {
                        if (_nameEditingController.text != '') {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(_user.uid)
                              .update(
                            {
                              'name': _nameEditingController.text,
                              'profile': _profileImageURL,
                              'email': _user.email,
                            },
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InitialGenreSelection(),
                            ),
                          );
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
