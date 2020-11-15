import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';

class RequestNewMusicianPage extends StatefulWidget {
  final UserDB userDB;

  const RequestNewMusicianPage({Key key, this.userDB}) : super(key: key);
  @override
  _RequestNewMusicianPageState createState() => _RequestNewMusicianPageState();
}

class _RequestNewMusicianPageState extends State<RequestNewMusicianPage> {
  TextEditingController _controller1;
  TextEditingController _controller2;
  ScrollController _scrollController;
  bool lastStatus = true;
  Map<String, bool> _route = {
    "SNS": false,
    "공연": false,
    "친구추천": false,
    "기타": false
  };

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (250 - kToolbarHeight);
  }

  _selectRoute(int val) {
    setState(() {
      for (var i = 0; i < _route.keys.length; i++) {
        _route[_route.keys.toList()[i]] = false;
      }
      _route[_route.keys.toList()[val]] = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _controller1 = TextEditingController(text: '');
    _controller2 = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250,
              floating: false,
              pinned: true,
              centerTitle: true,
              title: Text(
                '유니온 추천',
                style: TextStyle(
                  color: isShrink ? Colors.white : Colors.transparent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/live_header%2Fbanner_person_listening.png?alt=media&token=c073c465-924b-437e-a9e6-f5b644bdfa4d',
                  imageBuilder: (context, imageProvider) => Container(
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      '추천하고 싶은 뮤지션(밴드) 이름',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 40,
                      child: TextField(
                        controller: _controller1,
                        maxLines: 1,
                        autocorrect: false,
                        cursorHeight: 14,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: textFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      '뮤지션(밴드)를 어떻게 알게되셨나요?',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            _selectRoute(0);
                          },
                          child: _route[_route.keys.toList()[0]]
                              ? Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: appKeyColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[0],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: appKeyColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[0],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectRoute(1);
                          },
                          child: _route[_route.keys.toList()[1]]
                              ? Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: appKeyColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[1],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: appKeyColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[1],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectRoute(2);
                          },
                          child: _route[_route.keys.toList()[2]]
                              ? Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: appKeyColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[2],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: appKeyColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[2],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectRoute(3);
                          },
                          child: _route[_route.keys.toList()[3]]
                              ? Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: appKeyColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[3],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: appKeyColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  width: 69,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widgetRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _route.keys.toList()[3],
                                      style: TextStyle(
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 29.0,
                    ),
                    Text(
                      '뮤지션(밴드)의 노래중 가장 좋아하는 노래를 추천해주세요!',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 40,
                      child: TextField(
                        controller: _controller2,
                        maxLines: 1,
                        autocorrect: false,
                        cursorHeight: 14,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: textFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
                    ),
                    SizedBox(
                      height: 28.0,
                    ),
                    Center(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widgetRadius),
                        ),
                        color: appKeyColor,
                        onPressed: () async {
                          if ((_controller1.text != '') &&
                              (_controller2.text != '')) {
                            for (var i = 0; i < _route.keys.length; i++) {
                              if (_route[_route.keys.toList()[i]]) {
                                // Collection 불러오기
                                CollectionReference newUnionRequestCollection =
                                    FirebaseFirestore.instance
                                        .collection('NewUnionRequest');

                                await newUnionRequestCollection.add(
                                  {
                                    'id': widget.userDB.id.trim(),
                                    'name': _controller1.text.trim(),
                                    'route': _route.keys.toList()[i],
                                    'favorite_song': _controller2.text.trim(),
                                  },
                                ).then((value) async {
                                  String documentID = value.id;
                                  await newUnionRequestCollection
                                      .doc(documentID)
                                      .update({'document_id': documentID});
                                });

                                Navigator.of(context).pop();
                              }
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "내용을 입력해주세요",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[700],
                              textColor: Colors.white,
                              fontSize: textFontSize,
                            );
                          }
                        },
                        child: Text(
                          '추천하기',
                          style: TextStyle(
                            fontSize: textFontSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
