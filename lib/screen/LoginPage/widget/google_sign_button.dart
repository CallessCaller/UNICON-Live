import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/screen/LoginPage/widget_policy_check.dart';

import '../login_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class GoogleSignButton extends StatelessWidget {
  final bool isArtist;
  GoogleSignButton({this.isArtist});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        showAlertDialog(context);
        UserCredential userCredential = await signInWithGoogle();

        if (userCredential.user.uid == _auth.currentUser.uid) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(_auth.currentUser.uid)
              .get()
              .then((value) {
            if (value.exists == false) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PolicyCheckDialog(isArtist: isArtist),
                ),
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/inapp', (Route<dynamic> route) => false);
            }
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => PolicyCheckDialog(isArtist: isArtist),
            //   ),
            // );
          });
        }
      },
      color: Colors.white,
      textColor: Colors.white,
      child: Container(
        height: 25,
        width: 25,
        child: Image.asset('assets/login_btn/g-logo.png', fit: BoxFit.fitWidth),
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }
}
