import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:image/image.dart' as img;

class FeedWritePage extends StatefulWidget {
  final UserDB userDB;
  FeedWritePage({this.userDB});
  @override
  _FeedWritePageState createState() => _FeedWritePageState();
}

class _FeedWritePageState extends State<FeedWritePage> {
  File _image;
  bool _canGo = true;
  String _imageURL = '';
  TextEditingController _soundcloud = TextEditingController();
  TextEditingController _content = TextEditingController();
  FocusNode scFocus = new FocusNode();
  FocusNode contentFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _soundcloud.text = '';
    _content.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    scFocus.dispose();
    contentFocus.dispose();
    _soundcloud.dispose();
    _content.dispose();
  }

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          '글 작성하기',
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
        actions: [
          IconButton(
            color: appKeyColor,
            icon: Icon(
              Icons.check,
              size: 30,
            ),
            onPressed: _canGo
                ? () async {
                    scFocus.unfocus();
                    contentFocus.unfocus();
                    if (_content.text == '') {
                      Fluttertoast.showToast(
                        msg: "내용을 입력해주세요",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[700],
                        textColor: Colors.white,
                        fontSize: textFontSize,
                      );
                    } else {
                      bool check = false;

                      Map<String, dynamic> _uploadResult = {
                        'time': Timestamp.now().millisecondsSinceEpoch,
                        'content': _content.text.trim(),
                        'id': widget.userDB.id,
                        'like': [],
                      };

                      if (_soundcloud.text != '' &&
                          _soundcloud.text.contains('soundcloud.com')) {
                        if (_soundcloud.text.startsWith('https://')) {
                          _uploadResult['soundcloud'] = _soundcloud.text.trim();
                        } else {
                          _uploadResult['soundcloud'] =
                              'https://' + _soundcloud.text.trim();
                        }

                        check = true;
                      } else {
                        var _alertDialog = AlertDialog(
                          title: ListBody(children: [
                            Text(
                              "사운드클라우드 링크를 정확하게 입력하세요.",
                              style: TextStyle(
                                fontSize: textFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text('ex. soundcloud.com/ 형식')
                          ]),
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _alertDialog,
                        );
                      }

                      if (check) {
                        showCircleIndicator(context);
                        setState(() {
                          _canGo = false;
                        });
                        final feed = await FirebaseFirestore.instance
                            .collection('Feed')
                            .add(_uploadResult);

                        await FirebaseFirestore.instance
                            .collection('Feed')
                            .doc(feed.id)
                            .update({'feedID': feed.id});

                        if (_image != null) {
                          await _onlyUploadImage(feed.id);
                          await FirebaseFirestore.instance
                              .collection('Feed')
                              .doc(feed.id)
                              .update({
                            'image': _imageURL,
                          });
                        }

                        await widget.userDB.reference
                            .collection('my_post')
                            .doc(feed.id)
                            .set({'feedID': feed.id});

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    }
                  }
                : null,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사운드클라우드 음악 공유하기',
                style: title3,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                focusNode: scFocus,
                controller: _soundcloud,
                autocorrect: false,
                maxLines: 1,
                style: body3,
                decoration: InputDecoration(
                  hintText: 'https://soundcloud.com/',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appKeyColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: outlineColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '사진 공유하기',
                style: title3,
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _canGo = false;
                  });
                  _uploadImageToStorage(ImageSource.gallery);
                },
                child: _image == null
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(widgetRadius),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Icon(
                            Icons.image,
                            color: Colors.black,
                            size: 50,
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(widgetRadius),
                            color: Colors.white,
                            image: DecorationImage(
                                image: FileImage(_image), fit: BoxFit.cover),
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                        ),
                      ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 120.0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                  child: TextField(
                    focusNode: contentFocus,
                    controller: _content,
                    maxLines: 1000,
                    autocorrect: false,
                    style: body3,
                    decoration: InputDecoration(
                      hintText: '내용 입력...',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: appKeyColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(widgetRadius),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: outlineColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(widgetRadius),
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

  Future<void> _onlyUploadImage(String id) async {
    // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
    Reference storageReference = _firebaseStorage.ref().child("feed/" + id);

    // 파일 업로드
    // 파일 업로드 완료까지 대기
    await storageReference.putFile(_image);

    // 업로드한 사진의 URL 획득
    String downloadURL = await storageReference.getDownloadURL();

    // 업로드된 사진의 URL을 페이지에 반영
    setState(() {
      _imageURL = downloadURL;
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

      File resizedFile = File(pickedImage.path);
      // ..writeAsBytesSync(img.encodeJpg(resizedImg));
      setState(() {
        _image = resizedFile;
        _canGo = true;
      });
    }
  }
}

void showCircleIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(seconds: 10), () {});
}
