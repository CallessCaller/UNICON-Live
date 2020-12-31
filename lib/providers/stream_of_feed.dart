import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing_layout/model/feed.dart';

class StreamOfFeed {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Feed>> getFeeds() {
    // DocumentSnapshot 으로 되어 있기에 이를 리스트 형식으로 바꿔줌.
    var dateTime = DateTime.now();
    return _db
        .collection('Feed')
        .where('time',
            isGreaterThanOrEqualTo: new DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day - 10,
            ).millisecondsSinceEpoch)
        .orderBy('time', descending: true)
        .snapshots()
        .map((list) => list.docs.map((doc) => Feed.fromSnapshot(doc)).toList());
  }
}dddd
