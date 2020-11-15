import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:image/image.dart' as img;
import 'package:testing_layout/screen/FeedPage/screen/screen_feed_write_page.dart';

class FeedEditPage extends StatefulWidget {
  final Feed feed;
  final UserDB userDB;
  FeedEditPage({this.userDB, this.feed});
  @override
  _FeedEditPageState createState() => _FeedEditPageState();
}

class _FeedEditPageState extends State<FeedEditPage> {
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
    _soundcloud.text = widget.feed.soundcloud;
    _content.text = widget.feed.content;
    _imageURL = widget.feed.image;
  }

  @override
  void dispose() {
    super.dispose();
    _soundcloud.dispose();
    _content.dispose();
    scFocus.dispose();
    contentFocus.dispose();
  }

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          '피드 수정',
        ),
        actions: [
          IconButton(
            color: appKeyColor,
            icon: Icon(MdiIcons.check),
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
                        backgroundColor: Colors.black.withOpacity(0.7),
                        textColor: Colors.white,
                        fontSize: widgetFontSize,
                      );
                    } else {
                      showCircleIndicator(context);
                      setState(() {
                        _canGo = false;
                      });
                      await widget.feed.reference.update({
                        'isEdited': true,
                        'content': _content.text,
                        'soundcloud': _soundcloud.text,
                      });

                      if (_image != null) {
                        await _onlyUploadImage(widget.feed.feedID);
                        await widget.feed.reference.update({
                          'image': _imageURL,
                        });
                      }

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }
                : null,
          )
        ],
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '음악 공유하기 (선택)',
                style: TextStyle(
                  fontSize: textFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                focusNode: scFocus,
                controller: _soundcloud,
                autocorrect: false,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: widgetFontSize,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText:
                      'SoundCloud URL (ex. https://soundcloud.com/artist/title...)',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '사진 공유하기 (선택)',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w600,
                ),
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
                  child: _image == null && _imageURL == null
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
                      : _image == null
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(11),
                                  ),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(_imageURL),
                                      fit: BoxFit.cover),
                                ),
                                alignment: Alignment.center,
                                width: 340,
                                height: 340,
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
                                      fit: BoxFit.cover),
                                ),
                                alignment: Alignment.center,
                                width: 340,
                                height: 340,
                              ),
                            )),
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
                    maxLines: 7,
                    autocorrect: false,
                    style: TextStyle(
                      fontSize: widgetFontSize,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: widgetFontSize,
                        color: Colors.grey,
                      ),
                      hintText: '새 글 쓰기...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
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
      img.Image imageTmp =
          img.decodeImage(File(pickedImage.path).readAsBytesSync());
      img.Image resizedImg = img.copyResize(
        imageTmp,
        height: 1200,
      );

      File resizedFile = File(pickedImage.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImg));
      setState(() {
        _image = resizedFile;
        _canGo = true;
      });
    }
  }
}
