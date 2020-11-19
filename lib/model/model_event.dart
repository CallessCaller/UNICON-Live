import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String name;
  final String content;
  final String image;
  final Timestamp postTime;
  final DocumentReference reference;

  EventModel.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        content = map['content'],
        image = map['image'],
        postTime = map['post_time'];

  EventModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
