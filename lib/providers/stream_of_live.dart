import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing_layout/model/lives.dart';

class StreamOfLive {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Lives>> getLives() {
    // DocumentSnapshot 으로 되어 있기에 이를 리스트 형식으로 바꿔줌.
    return _db.collection('LiveTmp').snapshots().map(
        (list) => list.docs.map((doc) => Lives.fromSnapshot(doc)).toList());
  }
}
