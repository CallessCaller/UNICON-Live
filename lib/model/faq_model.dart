import 'package:cloud_firestore/cloud_firestore.dart';

class FAQModel {
  final String question;
  final String answer;
  final DocumentReference reference;

  FAQModel.fromMap(Map<String, dynamic> map, {this.reference})
      : question = map['question'],
        answer = map['answer'];

  FAQModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
