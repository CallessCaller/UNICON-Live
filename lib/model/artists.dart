import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  final String name;
  final String profile;
  final String id;
  final String youtubeLink;
  final String soudcloudLink;
  final String instagramId;
  final Timestamp birth;
  final bool liveNow;
  final List<dynamic> myPeople;
  final List<dynamic> genre;
  final List<dynamic> mood;
  final int fee;
  final DocumentReference reference;

  Artist.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        profile = map['profile'],
        id = map['id'],
        youtubeLink = map['youtube_link'],
        soudcloudLink = map['soundcloud_link'],
        instagramId = map['instagram_id'],
        birth = map['birth'],
        myPeople = map['my_people'],
        genre = map['genre'],
        mood = map['mood'],
        liveNow = map['live_now'],
        fee = map['fee'];

  Artist.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => '';
}
