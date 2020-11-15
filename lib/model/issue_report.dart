import 'package:cloud_firestore/cloud_firestore.dart';

class IssueReport {
  final String id;
  final String issueID;
  final Timestamp reportDate;
  final String type;
  final String screenshot;
  final String content;
  final DocumentReference reference;

  IssueReport.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        issueID = map['issue_id'],
        reportDate = map['report_date'],
        type = map['type'],
        screenshot = map['screenshot'],
        content = map['content'];

  IssueReport.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
