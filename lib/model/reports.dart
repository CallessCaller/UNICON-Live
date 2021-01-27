import 'package:cloud_firestore/cloud_firestore.dart';

class Reports {
  final String id;
  final String report_id;
  final Timestamp report_time;
  final String report_name;
  final String type;
  final DocumentReference reference;
  Reports.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
      report_id = map['report_id'],
      report_name = map['report_name'],
      report_time = map['report_time'],
      type = map['type'];
  Reports.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);


  @override
  String toString() => '';
}