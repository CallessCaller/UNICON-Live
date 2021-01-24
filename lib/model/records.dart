import 'package:cloud_firestore/cloud_firestore.dart';

class Records {
  final String name;
  final Timestamp date;
  List<dynamic> total;
  final int size;
  final DocumentReference reference;
  List<dynamic> liked;

  Records.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        date = map['date'],
        total = map['total'],
        size = map['size'],
        liked = map['liked'];

  Records.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
