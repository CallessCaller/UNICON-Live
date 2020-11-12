import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  void _onLikePressed(UserDB userDB) async {
    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    setState(() {
      // Add data to CandidatesDB
      if (!widget.artist.myPeople.contains(widget.userDB.id)) {
        widget.artist.myPeople.add(userDB.id);
        userDB.follow.add(widget.artist.id);
        if (_live) {
          _firebaseMessaging.subscribeToTopic(widget.artist.id + 'live');
        }
        if (_feed) {
          _firebaseMessaging.subscribeToTopic(widget.artist.id + 'Feed');
        }
      }

      // Unliked
      else {
        widget.artist.myPeople.remove(userDB.id);
        // Delete data from UsersDB

        userDB.follow.remove(widget.artist.id);
        if (_live) {
          _firebaseMessaging.unsubscribeFromTopic(widget.artist.id + 'live');
        }
        if (_feed) {
          _firebaseMessaging.unsubscribeFromTopic(widget.artist.id + 'Feed');
        }
      }
    });
    await widget.artist.reference.update({'my_people': widget.artist.myPeople});
    await userDB.reference.update({'follow': userDB.follow});
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
                  image: DecorationImage(
                    image: NetworkImage(widget.artist.profile),
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
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.all(widgetDefaultPadding * 0.5),
                                child: Center(
                                  child: Text(
                                    'ON-AIR',
                                    style: TextStyle(
                                      color: appKeyColor,
                                      fontSize: widgetFontSize,
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
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.artist.myPeople.contains(widget.userDB.id)
                      ? MdiIcons.heart
                      :
                      // 라이크되면 MdiIcons.heart
                      MdiIcons.heartOutline,
                  size: 30,
                  color: appKeyColor.withOpacity(0.7),
                ),
                onPressed: () {
                  _onLikePressed(widget.userDB);
                },
                splashColor: Colors.transparent,
                splashRadius: 3.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
