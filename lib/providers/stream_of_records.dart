import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing_layout/model/records.dart';

class StreamOfRecords {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Records>> getRecords() {
    // DocumentSnapshot 으로 되어 있기에 이를 리스트 형식으로 바꿔줌.
    return _db.collection('Records').orderBy('date').snapshots().map(
        (list) => list.docs.map((doc) => Records.fromSnapshot(doc)).toList());
  }
}
