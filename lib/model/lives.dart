import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: 라이브 시청자 수 새 필드 생성
class Lives {
  final String id;
  final Timestamp time;
  List<dynamic> viewers;
  final String concertID;
  List<dynamic> payList;
  final DocumentReference reference;

  Lives.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        time = map['time'],
        viewers = map['viewers'],
        concertID = map['concertID'],
        payList = map['pay_list'];

  Lives.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
