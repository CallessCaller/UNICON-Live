import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/widget/instagram_link_box.dart';
import 'package:testing_layout/screen/UnionPage/widget/soundcloud_link_box.dart';
import 'package:testing_layout/screen/UnionPage/widget/union_donate.dart';
import 'package:testing_layout/screen/UnionPage/widget/youtube_link_box.dart';
import 'package:testing_layout/screen/UnionPage/widget/live_indicator_profile.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';

class UnionInfoPageHeader extends StatefulWidget {
  final Artist artist;
  final UserDB userDB;

  const UnionInfoPageHeader({
    Key key,
    this.userDB,
    this.artist,
  }) : super(key: key);

  @override
  _UnionInfoPageHeaderState createState() => _UnionInfoPageHeaderState();
}

class _UnionInfoPageHeaderState extends State<UnionInfoPageHeader> {
  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  SharedPreferences _preferences;
  bool _live = true;
  bool _feed = true;

  void _loadSetting() async {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 25,
        ),
        widget.artist.liveNow
            ? Center(child: LiveIndicatorProfile(artist: widget.artist))
            : Center(
                child: SizedBox(
                  width: 110,
                  height: 110,
                  child: CachedNetworkImage(
                    imageUrl: widget.artist.profile,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: appKeyColor,
                ),
              ),
            ),
            child: Text(
              widget.artist.name,
              style: title2,
            ),
          ),
        ),
        SizedBox(height: 7),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text(
              '팔로워 ${widget.artist.myPeople.length}명',
              style: subtitle1,
            ),
          ),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            _onLikePressed(widget.userDB);
          },
          child: widget.artist.myPeople.contains(widget.userDB.id)
              ? Container(
                  height: 30,
                  width: (MediaQuery.of(context).size.width - 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widgetRadius),
                    border: Border.all(color: appKeyColor, width: 1.2),
                  ),
                  child: Center(
                    child: Text(
                      '팔로잉',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: appKeyColor,
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 30,
                  width: (MediaQuery.of(context).size.width - 60),
                  decoration: BoxDecoration(
                    color: appKeyColor,
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  child: Center(
                    child: Text(
                      '팔로우',
                      style: subtitle2,
                    ),
                  ),
                ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InstagramLinkBox(instagramID: widget.artist.instagramId),
            YoutubeLinkBox(youtubeUrl: widget.artist.youtubeLink),
            SoundcloudLinkBox(soundcloudUrl: widget.artist.soudcloudLink),
            UnionDonate(userDB: widget.userDB, artist: widget.artist),
          ],
        ),
        SizedBox(height: 20),
        _buildGenreMoodRow(),
      ],
    );
  }

  Widget _buildGenreMoodRow() {
    List<Widget> res = [];
    print(widget.artist.genre);
    if (widget.artist.genre != null) {
      if (widget.artist.genre.length == 0) {
        res.add(
          Chip(
            shape: StadiumBorder(
              side: BorderSide(
                color: outlineColor,
                width: 1,
              ),
            ),
            backgroundColor: Colors.black,
            label: Text(
              '장르 X',
              style: body4,
            ),
          ),
        );
      } else {
        for (var i = 0; i < widget.artist.genre.length; i++) {
          res.add(
            Chip(
              shape: StadiumBorder(
                side: BorderSide(
                  color: outlineColor,
                  width: 2,
                ),
              ),
              backgroundColor: Colors.black,
              label: Text(
                widget.artist.genre[i],
                style: body4,
              ),
            ),
          );
          if (i != widget.artist.genre.length - 1) {
            res.add(
              SizedBox(width: 10),
            );
          }
        }
      }
    }

    res.add(
      Container(
        height: 20,
        child: VerticalDivider(
          color: Colors.white,
          width: 20,
          thickness: 2,
        ),
      ),
    );

    if (widget.artist.mood != null) {
      if (widget.artist.mood.length == 0) {
        res.add(
          Chip(
            shape: StadiumBorder(
              side: BorderSide(
                color: outlineColor,
                width: 1,
              ),
            ),
            backgroundColor: Colors.black,
            label: Text(
              '무드 X',
              style: body4,
            ),
          ),
        );
      } else {
        for (var i = 0; i < widget.artist.mood.length; i++) {
          res.add(
            Chip(
              shape: StadiumBorder(
                side: BorderSide(
                  color: outlineColor,
                  width: 1,
                ),
              ),
              backgroundColor: Colors.black,
              label: Text(
                widget.artist.mood[i],
                style: body4,
              ),
            ),
          );
          if (i != widget.artist.mood.length - 1) {
            res.add(
              SizedBox(width: 10),
            );
          }
        }
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: res,
      ),
    );
  }
}
