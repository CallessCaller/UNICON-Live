import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/union_page.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';

class LikedMusicianBox extends StatefulWidget {
  final Artist artist;
  final UserDB userDB;
  LikedMusicianBox({this.artist, this.userDB});

  @override
  _LikedMusicianBoxState createState() => _LikedMusicianBoxState();
}

class _LikedMusicianBoxState extends State<LikedMusicianBox> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _loadFirst();
  }

  SharedPreferences _preferences;
  bool _live = true;
  bool _feed = true;

  void _loadFirst() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      // SharedPreferences에 counter로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _live = (_preferences.getBool('_live') ?? true);
      _feed = (_preferences.getBool('_feed') ?? true);
    });
  }

  void _onLikePressed() async {
    var artistSnap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .get();
    Artist artist = Artist.fromSnapshot(artistSnap);

    var userSnap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userDB.id)
        .get();
    UserDB userDB = UserDB.fromSnapshot(userSnap);
    // Add data to CandidatesDB
    if (!artist.myPeople.contains(widget.userDB.id)) {
      artist.myPeople.add(userDB.id);
      userDB.follow.add(widget.artist.id);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(artist.id)
          .update({'my_people': artist.myPeople});
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDB.id)
          .update({'follow': userDB.follow});

      if (_live) {
        await _firebaseMessaging.subscribeToTopic(artist.id + 'live');
      }
      if (_feed) {
        await _firebaseMessaging.subscribeToTopic(artist.id + 'Feed');
      }
    }

    // Unliked
    else {
      artist.myPeople.remove(userDB.id);
      userDB.follow.remove(artist.id);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(artist.id)
          .update({'my_people': artist.myPeople});
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDB.id)
          .update({'follow': userDB.follow});

      await _firebaseMessaging.unsubscribeFromTopic(artist.id + 'live');

      await _firebaseMessaging.unsubscribeFromTopic(artist.id + 'Feed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UnionInfoPage(
              artist: widget.artist,
              userDB: widget.userDB,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(widgetDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widgetRadius),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: outlineColor,
                    width: .5,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.artist.resizedProfile != null &&
                            widget.artist.resizedProfile != ''
                        ? widget.artist.resizedProfile
                        : widget.artist.profile),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(widgetRadius),
                ),
              ),
              SizedBox(
                width: widgetDefaultPadding,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.artist.liveNow != null && widget.artist.liveNow
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.artist.name,
                                softWrap: true,
                                style: subtitle2,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.all(widgetDefaultPadding * 0.5),
                                child: Center(
                                  child: Text(
                                    'ON-AIR',
                                    style: TextStyle(
                                      color: appKeyColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Text(
                            widget.artist.name,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                    SizedBox(
                      height: widgetDefaultPadding * 0.5,
                    ),
                    Text(
                      widget.artist.genre != null
                          ? widget.artist.genre.join(' / ')
                          : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              widget.artist.myPeople.contains(widget.userDB.id)
                  ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        '팔로잉',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: outlineColor,
                        ),
                      ),
                      onPressed: () {
                        _onLikePressed();
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: outlineColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: 50,
                      height: 30,
                    )
                  : FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        '팔로우',
                        style: body3,
                      ),
                      onPressed: () {
                        _onLikePressed();
                      },
                      color: appKeyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: 50,
                      height: 30,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
