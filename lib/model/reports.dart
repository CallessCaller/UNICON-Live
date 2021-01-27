import 'package:cloud_firestore/cloud_firestore.dart';

class Reports {
  final String id;
  final String report_id;
  final DocumentReference reference;
  Reports.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
      report_id = map['report_id'];
  Reports.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);


  @override
  String toString() => '';
}