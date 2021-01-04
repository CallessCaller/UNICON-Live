import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_write_page.dart';

class BroadcastSetting extends StatefulWidget {
  final UserDB userDB;
  BroadcastSetting({this.userDB});
  @override
  _BroadcastSettingState createState() => _BroadcastSettingState();
}

class _BroadcastSettingState extends State<BroadcastSetting> {
  File _image;
  bool _canGo = true;
  String _imageURL = '';
  String _resizedURL = '';
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  TextEditingController titleController = new TextEditingController(text: '');
  TextEditingController feeController = new TextEditingController(text: '');
  FocusNode titleFocus = new FocusNode();
  FocusNode feeFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    feeController.text =
        widget.userDB.fee != null ? widget.userDB.fee.toString() : 0.toString();
    titleController.text = widget.userDB.liveTitle ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    feeController.dispose();
    titleFocus.dispose();
    feeFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '콘서트 설정',
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
        actions: [
          FlatButton(
            child: Text(
              '저장',
              style: TextStyle(
                color: appKeyColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: _canGo
                ? () async {
                    showCircleIndicator(context);
                    if (feeController.text != '') {
                      int stringToInt = int.parse(feeController.text);
                      await widget.userDB.reference
                          .update({'fee': stringToInt});
                    } else {
                      await widget.userDB.reference.update({'fee': 0});
                    }

                    await widget.userDB.reference
                        .update({'liveTitle': titleController.text});

                    if (_image != null) {
                      await _onlyUploadImage(widget.userDB.id);
                      await widget.userDB.reference.update({
                        'liveImage': _imageURL,
                        'resizedLiveImage': _resizedURL
                      });
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                : null,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text('미리보기',
                          style: subtitle1, textAlign: TextAlign.left)),
                ],
              ),
              Divider(),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(widgetRadius),
                  image: DecorationImage(
                    image: _image == null
                        ? widget.userDB.liveImage == null
                            ? NetworkImage(widget.userDB.profile)
                            : widget.userDB.resizedLiveImage != null &&
                                    widget.userDB.resizedLiveImage != ''
                                ? NetworkImage(widget.userDB.resizedLiveImage)
                                : NetworkImage(widget.userDB.liveImage)
                        : FileImage(_image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 10,
                      child: Row(
                        children: [
                          Icon(
                            UniIcon.profile,
                            size: 20,
                          ),
                          SizedBox(width: 3),
                          Text(
                            '42',
                            style: TextStyle(
                                fontSize: widgetFontSize, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 5,
                      width: MediaQuery.of(context).size.width * 0.9 - 12,
                      height: 55,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(6)),
                        clipBehavior: Clip.antiAlias,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            color: Colors.black.withOpacity(0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6)),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(widget.userDB.profile),
                                ),
                                VerticalDivider(
                                  width: 10,
                                  color: Colors.transparent,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        titleController.text == ''
                                            ? widget.userDB.name
                                            : titleController.text,
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        titleController.text == ''
                                            ? '라이브 방송중'
                                            : '${widget.userDB.name}님의 라이브 방송',
                                        style: TextStyle(
                                          fontSize: textFontSize - 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    feeController.text == '' || feeController.text == '0'
                        ? SizedBox()
                        : Positioned(
                            top: 5,
                            right: 10,
                            child: Row(
                              children: [
                                Icon(
                                  UniIcon.unicoin,
                                  color: appKeyColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  feeController.text.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                    Positioned(
                      bottom: 10,
                      right: 5,
                      child: Text(
                        '##분 전',
                        style: TextStyle(
                          fontSize: textFontSize - 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 30,
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _canGo = false;
                  });
                  _uploadImageToStorage(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text('콘서트 이미지 변경',
                            style: TextStyle(
                              color: appKeyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left)),
                  ],
                ),
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                      child: Text('콘서트 타이틀',
                          style: subtitle1, textAlign: TextAlign.left)),
                ],
              ),
              Divider(),
              TextField(
                onEditingComplete: () {
                  titleFocus.unfocus();
                },
                focusNode: titleFocus,
                controller: titleController,
                textAlign: TextAlign.left,
                style: subtitle1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 3,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: outlineColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appKeyColor,
                    ),
                  ),
                  labelText: '타이틀 입력',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                      child: Text('콘서트 요금',
                          style: subtitle1, textAlign: TextAlign.left)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: TextField(
                      focusNode: feeFocus,
                      controller: feeController,
                      textAlign: TextAlign.left,
                      style: subtitle1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 3,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: outlineColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appKeyColor,
                          ),
                        ),
                        labelText:
                            widget.userDB.fee == null || widget.userDB.fee == 0
                                ? '현재 입장료: 무료(0코인)'
                                : '현재 입장료: ${feeController.text} 코인',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    color: appKeyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widgetRadius),
                    ),
                    onPressed: () {
                      feeFocus.unfocus();
                    },
                    child: Text(
                      '적용',
                      style: subtitle3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onlyUploadImage(String id) async {
    // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
    Reference storageReference = _firebaseStorage.ref().child("live/" + id);

    // 파일 업로드
    // 파일 업로드 완료까지 대기
    await storageReference.putFile(_image);

    // 업로드한 사진의 URL 획득
    String downloadURL = await storageReference.getDownloadURL();
    String resizedURL = '';
    try {
      resizedURL = await FirebaseStorage.instance
          .ref('/live/${id}_1080x1080')
          .getDownloadURL();
    } catch (e) {
      print(e);
    }
    // 업로드된 사진의 URL을 페이지에 반영
    setState(() {
      _imageURL = downloadURL;
      _resizedURL = resizedURL;
      _canGo = true;
    });
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
      // img.Image imageTmp =
      //     img.decodeImage(File(pickedImage.path).readAsBytesSync());
      // img.Image resizedImg = img.copyResize(
      //   imageTmp,
      //   height: 3400,
      // );

      File imageFile = File(pickedImage.path);
      // ..writeAsBytesSync(img.encodeJpg(resizedImg));
      setState(() {
        _image = imageFile;
        _canGo = true;
      });
    }
  }
}
