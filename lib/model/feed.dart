import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  final String id;
  final String feedID;
  final String content;
  final String image;
  final String soundcloud;
  final String progressive;
  final String title;
  final int time;
  final bool isEdited;
  final List<dynamic> like;
  final String artwork;
  final DocumentReference reference;

  Feed.fromMap(Map<String, dynamic> map, {this.reference})
      : content = map['content'],
        id = map['id'],
        feedID = map['feedID'],
        image = map['image'],
        soundcloud = map['soundcloud'],
        progressive = map['progressive'],
        title = map['title'],
        time = map['time'],
        isEdited = map['isEdited'],
        like = map['like'],
        artwork = map['artwork'];

  Feed.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => '';
}
