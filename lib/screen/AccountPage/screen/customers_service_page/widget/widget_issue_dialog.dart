import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';

class IssueDialogWidget extends StatefulWidget {
  final UserDB userDB;
  const IssueDialogWidget({this.userDB});
  @override
  _IssueDialogWidgetState createState() => _IssueDialogWidgetState();
}

class _IssueDialogWidgetState extends State<IssueDialogWidget> {
  List<String> reportTypes = [
    '유니콘에게 제안하기',
    '버그 신고하기',
    '계정 문의하기',
  ];
  File _image;
  bool _canGo = true;
  String _imageURL = '';
  String _type;
  TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
    _type = reportTypes[0];
  }

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '유니콘 진짜 도와줘!',
          style: headline2,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
                    '분류 선택하기 *',
                    style: subtitle1,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - defaultPadding * 2,
                child: DropdownButton<String>(
                  isExpanded: true,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.65),
                  ),
                  value: _type,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white.withOpacity(0.65),
                    size: 25,
                  ),
                  iconSize: 20,
                  underline: Container(
                    color: Colors.transparent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _type = newValue;
                    });
                  },
                  items:
                      reportTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: body2,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '스크린샷',
                    style: subtitle1,
                  ),
                ),
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(11),
                            ),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          width: 340,
                          height: 340,
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(11),
                            ),
                            color: Colors.white,
                            image: DecorationImage(
                              image: FileImage(_image),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          alignment: Alignment.center,
                          width: 340,
                          height: 340,
                        ),
                      ),
              ),
              SizedBox(height: 10),
              Container(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '본문 *',
                    style: subtitle1,
                  ),
                ),
              ),
              TextField(
                controller: _controller,
                maxLines: 7,
                autocorrect: false,
                cursorHeight: 14,
                keyboardType: TextInputType.multiline,
                style: body2,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widgetRadius)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widgetRadius)),
                    borderSide: BorderSide(
                      color: appKeyColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: FlatButton(
                  height: 40,
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: _canGo
                      ? () async {
                          if (_controller.text == '') {
                            Fluttertoast.showToast(
                              msg: "내용을 입력해주세요",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: dialogColor1,
                              textColor: Colors.white,
                              fontSize: textFontSize,
                            );
                          } else {
                            setState(() {
                              _canGo = false;
                              _isLoading = true;
                            });
                            final issue = await FirebaseFirestore.instance
                                .collection('IssueReports')
                                .add(
                              {
                                'report_date': Timestamp.now(),
                                'content': _controller.text,
                                'type': _type,
                                'id': widget.userDB.id,
                              },
                            );

                            await FirebaseFirestore.instance
                                .collection('IssueReports')
                                .doc(issue.id)
                                .update({'issue_id': issue.id});

                            if (_image != null) {
                              await _onlyUploadImage(issue.id);
                              await FirebaseFirestore.instance
                                  .collection('IssueReports')
                                  .doc(issue.id)
                                  .update({
                                'image': _imageURL,
                              });
                            }

                            await widget.userDB.reference
                                .collection('my_issues')
                                .doc(issue.id)
                                .set({'issue_id': issue.id});

                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  color: appKeyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "제출",
                          style: subtitle1,
                        ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onlyUploadImage(String id) async {
    // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
    Reference storageReference =
        _firebaseStorage.ref().child("issue_reports/" + id);

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

  _uploadImageToStorage(ImageSource source) async {
    // File image = await ImagePicker.pickImage(source: source);
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedImage = await imagePicker.getImage(source: source);

    if (pickedImage == null) {
      setState(() {
        // _profileImageURL = _user.photoURL;
        _canGo = true;
      });
    } else {
      setState(() {
        _image = File(pickedImage.path);
        _canGo = true;
      });
    }
  }
}
