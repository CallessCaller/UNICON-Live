import 'package:cloud_firestore/cloud_firestore.dart';

class StreamOfArtist {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getArtists() {
    // DocumentSnapshot 으로 되어 있기에 이를 리스트 형식으로 바꿔줌.
    return _db
        .collection('Users')
        .where('is_artist', isEqualTo: true)
        .snapshots()
        .map((list) => list);
  }
}
