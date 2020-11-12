import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:testing_layout/model/users.dart';

class StreamOfuser {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserDB> getUser(String id) {
    var snapshot = _db.collection('Users').doc(id).snapshots();

    return snapshot.map((event) => UserDB.fromSnapshot(event));
  }
}

Stream<UserDB> streamOfUsers(String id) {
  var ref = FirebaseFirestore.instance.collection('Users').doc(id);
  return ref.snapshots().map((list) => UserDB.fromSnapshot(list));
}
