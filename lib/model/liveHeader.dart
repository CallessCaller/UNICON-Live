import 'package:cloud_firestore/cloud_firestore.dart';

class LiveHeaderModel {
  final String image;
  final String id;
  final DocumentReference reference;

  LiveHeaderModel.fromMap(Map<String, dynamic> map, {this.reference})
      : image = map['image'],
        id = map['id'];

  LiveHeaderModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
