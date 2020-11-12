import 'package:cloud_firestore/cloud_firestore.dart';

class UserDB {
  final String name;
  final String email;
  final String instagramId;
  final String youtubeLink;
  final String soudcloudLink;
  final String profile;
  final String id;
  String token;
  int points;
  final bool isArtist;
  final List<dynamic> follow;
  final Timestamp birth;
  final List<dynamic> preferredGenre;
  final List<dynamic> preferredMood;
  final List<dynamic> genre;
  final List<dynamic> mood;
  int fee;
  final Timestamp createTime;
  final DocumentReference reference;

  UserDB.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        email = map['email'],
        instagramId = map['instagram_id'],
        youtubeLink = map['youtube_link'],
        soudcloudLink = map['soundcloud_link'],
        profile = map['profile'],
        id = map['id'],
        token = map['token'],
        points = map['points'],
        isArtist = map['is_artist'],
        follow = map['follow'],
        birth = map['birth'],
        preferredGenre = map['preferred_genre'],
        preferredMood = map['preferred_mood'],
        genre = map['genre'],
        mood = map['mood'],
        fee = map['fee'],
        createTime = map['createTime'];

  UserDB.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => '';
}
