import 'package:cloud_firestore/cloud_firestore.dart';

class CoinTransaction {
  final Timestamp time;
  final int amount;
  final int type; // 0 : event , 1 : charge , 2 : donated , 3 : donate
  final String who;
  final String whoseID;
  final DocumentReference reference;

  CoinTransaction.fromMap(Map<String, dynamic> map, {this.reference})
      : time = map['time'],
        amount = map['amount'],
        type = map['type'],
        who = map['who'],
        whoseID = map['whoseID'];

  CoinTransaction.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
