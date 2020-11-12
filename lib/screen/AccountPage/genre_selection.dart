import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';

class GenreSelectionPage extends StatefulWidget {
  final UserDB userDB;
  const GenreSelectionPage({this.userDB});
  @override
  _GenreSelectionPageState createState() => _GenreSelectionPageState();
}

class _GenreSelectionPageState extends State<GenreSelectionPage> {
  Map<String, bool> _genreMap = Map.fromIterable(
    genreTotalList,
    key: (element) => element,
    value: (element) => false,
  );

  Map<String, bool> _moodMap = Map.fromIterable(
    moodTotalList,
    key: (element) => element,
    value: (element) => false,
  );

  _initializeSetting() {
    for (var i = 0; i < _genreMap.length; i++) {
      for (var j = 0; j < widget.userDB.preferredGenre.length; j++) {
        if (_genreMap.keys.toList()[i] == widget.userDB.preferredGenre[j]) {
          _genreMap[_genreMap.keys.toList()[i]] = true;
        }
      }
    }
    for (var i = 0; i < _moodMap.length; i++) {
      for (var j = 0; j < widget.userDB.preferredMood.length; j++) {
        if (_moodMap.keys.toList()[i] == widget.userDB.preferredMood[j]) {
          _moodMap[_moodMap.keys.toList()[i]] = true;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSetting();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: Text('취향 선택하기'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '장르',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Divider(
                height: 0,
                thickness: 1,
                color: Colors.white.withOpacity(0.65),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 20,
                runSpacing: 10,
                children: _buildGenre(),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '분위기',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Divider(
                height: 0,
                thickness: 1,
                color: Colors.white.withOpacity(0.65),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 20,
                runSpacing: 10,
                children: _buildMood(),
              ),
              SizedBox(height: 50),
              FlatButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget.userDB.id)
                      .update(
                    {
                      'preferred_genre': _makeLikedGenreList(),
                      'preferred_mood': _makeLikedMoodList(),
                    },
                  );
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widgetRadius),
                ),
                color: appKeyColor,
                child: Text(
                  '선택 완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGenre() {
    List<Widget> genreChildren = [];
    for (var index = 0; index < _genreMap.length; index++) {
      genreChildren.add(
        InkWell(
          onTap: () {
            _selectGenre(index);
          },
          child: _genreMap[_genreMap.keys.toList()[index]]
              ? Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appKeyColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _genreMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: textFontSize,
                      color: appKeyColor,
                    ),
                  ),
                )
              : Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _genreMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: textFontSize,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      );
    }
    return genreChildren;
  }

  List<Widget> _buildMood() {
    List<Widget> moodChildren = [];
    for (var index = 0; index < _moodMap.length; index++) {
      moodChildren.add(
        InkWell(
          onTap: () {
            _selectMood(index);
          },
          child: _moodMap[_moodMap.keys.toList()[index]]
              ? Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appKeyColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _moodMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: textFontSize,
                      color: appKeyColor,
                    ),
                  ),
                )
              : Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _moodMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: textFontSize,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      );
    }
    return moodChildren;
  }

  _selectGenre(int val) {
    setState(() {
      _genreMap[_genreMap.keys.toList()[val]] =
          !_genreMap[_genreMap.keys.toList()[val]];
    });
  }

  _selectMood(int val) {
    setState(() {
      _moodMap[_moodMap.keys.toList()[val]] =
          !_moodMap[_moodMap.keys.toList()[val]];
    });
  }

  _makeLikedGenreList() {
    List<String> res = [];
    for (var index = 0; index < _genreMap.length; index++) {
      if (_genreMap[_genreMap.keys.toList()[index]]) {
        res.add(_genreMap.keys.toList()[index]);
      }
    }
    return res;
  }

  _makeLikedMoodList() {
    List<String> res = [];
    for (var index = 0; index < _moodMap.length; index++) {
      if (_moodMap[_moodMap.keys.toList()[index]]) {
        res.add(_moodMap.keys.toList()[index]);
      }
    }
    return res;
  }
}
