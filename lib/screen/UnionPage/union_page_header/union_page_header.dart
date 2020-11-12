import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/UnionPage/sns_links/instagram_link_box.dart';
import 'package:testing_layout/screen/UnionPage/sns_links/soundcloud_link_box.dart';
import 'package:testing_layout/screen/UnionPage/sns_links/unionfeedtotal.dart';
import 'package:testing_layout/screen/UnionPage/sns_links/youtube_link_box.dart';
import 'package:testing_layout/screen/UnionPage/union_page_header/live_indicator_profile.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 25,
        ),
        widget.artist.liveNow
            ? LiveIndicatorProfile(artist: widget.artist)
            : SizedBox(
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
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: 157,
          height: 30,
          child: Center(
            child: Text(
              widget.artist.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: subtitleFontSize,
              ),
            ),
          ),
        ),
        Container(
          width: 157.0,
          height: 0.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: appKeyColor,
              width: 1.0,
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InstagramLinkBox(instagramID: widget.artist.instagramId),
            YoutubeLinkBox(youtubeUrl: widget.artist.youtubeLink),
            SoundcloudLinkBox(soundcloudUrl: widget.artist.soudcloudLink),
            UnionFeedTotal(userDB: widget.userDB, id: widget.artist.id),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _onLikePressed(widget.userDB);
              },
              child: widget.artist.myPeople.contains(widget.userDB.id)
                  ? Container(
                      height: 30,
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      decoration: BoxDecoration(
                        color: appKeyColor,
                        borderRadius: BorderRadius.circular(widgetRadius),
                      ),
                      child: Center(
                        child: Text(
                          '팔로잉',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: textFontSize,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 30,
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(widgetRadius),
                      ),
                      child: Center(
                        child: Text(
                          '팔로우',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: textFontSize,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () {},
              child: Container(
                height: 30,
                width: (MediaQuery.of(context).size.width - 60) / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widgetRadius),
                ),
                child: Center(
                  child: Text(
                    '공유하기',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: textFontSize,
                      color: appKeyColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
