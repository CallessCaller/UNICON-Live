import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String name;
  final String content;
  final Timestamp postTime;
  final DocumentReference reference;

  NotificationModel.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        content = map['content'],
        postTime = map['post_time'];

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
