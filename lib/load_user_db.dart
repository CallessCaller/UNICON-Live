import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'model/users.dart';

class LoadUser {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _uid;
  String _displayName;
  String _email;
  String _profile;
  UserDB oneTimeUserDB;

  LoadUser() {
    loadUser();
  }

  void loadUser() {
    final User user = _auth.currentUser;
    _uid = user.uid;
    _displayName = user.displayName;
    _email = user.email;
    _profile = user.photoURL;
  }

  void onCreate() {
    void createDB() {
      DateTime currentTime = DateTime.now();
      FirebaseFirestore.instance.collection('Users').doc(_uid).set({
        'id': _uid,
        'createTime': currentTime,
        'is_artist': false,
        'profile': _profile == null
            ? 'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/unnamed.png?alt=media&token=5b656cb4-055c-4734-a93b-b3c9c629fc5a'
            : _profile,
        'name': _displayName ?? '익명',
        'email': _email ?? '',
        'points': 0,
        'youtube_link': '',
        'soundcloud_link': '',
        'instagram_id': '',
        'my_people': [],
        'follow': [],
        'preferred_genre': [],
        'preferred_mood': [],
        'mood': [],
        'genre': [],
        'live_now': false,
        'pay_list': [],
        'dislikePeople': [],
        'dislikeFeed': [],
        'dislikeChat': [],
        'dislikeComment': [],
        'fee': 0,
        'haters': [],
      });

      FirebaseFirestore.instance
          .collection('Users')
          .doc(_uid)
          .collection('unicoin_history')
          .doc('empty')
          .set({
        'when': '',
        'amount': 0,
        'donate': false,
      });

      FirebaseFirestore.instance
          .collection('Users')
          .doc(_uid)
          .collection('my_recommend')
          .doc('empty')
          .set({
        'artist_name': '',
      });

      // doc_id == post_id
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_uid)
          .collection('my_post')
          .doc('empty')
          .set({
        'post_id': '',
      });

      // doc_id == concert_id
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_uid)
          .collection('my_concerts')
          .doc('empty')
          .set({'concert_id': '', 'content': ''});
    }

    FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .get()
        .then((value) {
      if (value.exists == false) {
        createDB();
      }
    });
  }
}
