import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_wait_for_auth_page.dart';

class UnionMoodSelection extends StatefulWidget {
  @override
  _UnionMoodSelectionState createState() => _UnionMoodSelectionState();
}

class _UnionMoodSelectionState extends State<UnionMoodSelection> {
  // ignore: deprecated_member_use
  List<int> _selectedItems = List<int>();
  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '당신의 음악 무드는?',
          style: headline2,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          FlatButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(_user.uid)
                  .update(
                {
                  'mood': _makeMoodList(),
                },
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => WaitForAuth(),
                ),
                (route) => false,
              );
            },
            child: Text(
              '완료',
              style: TextStyle(color: appKeyColor),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: moodTotalList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              moodTotalList[index],
            ),
            trailing: (_selectedItems.contains(index))
                ? Icon(
                    Icons.check,
                    color: appKeyColor,
                  )
                : null,
            onTap: () {
              if (!_selectedItems.contains(index)) {
                setState(() {
                  _selectedItems.add(index);
                });
              } else {
                setState(() {
                  _selectedItems.removeWhere((val) => val == index);
                });
              }
            },
          );
        },
      ),
    );
  }

  _makeMoodList() {
    List<String> res = [];
    for (var j = 0; j < _selectedItems.length; j++) {
      res.add(moodTotalList[_selectedItems[j]]);
    }
    return res;
  }
}
