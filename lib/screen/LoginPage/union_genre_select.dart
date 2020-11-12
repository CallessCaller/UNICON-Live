import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/LoginPage/union_mood_selection.dart';

class UnionGenreSelection extends StatefulWidget {
  @override
  _UnionGenreSelectionState createState() => _UnionGenreSelectionState();
}

class _UnionGenreSelectionState extends State<UnionGenreSelection> {
  List<int> _selectedItems = List<int>();

  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('당신의 음악 장르는?'),
        actions: [
          FlatButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(_user.uid)
                  .update(
                {
                  'genre': _makeGenreList(),
                },
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UnionMoodSelection(),
                ),
              );
            },
            child: Text(
              '다음',
              style: TextStyle(color: appKeyColor),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: genreTotalList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              genreTotalList[index],
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
              print(_selectedItems);
            },
          );
        },
      ),
    );
  }

  _makeGenreList() {
    List<String> res = [];
    for (var j = 0; j < _selectedItems.length; j++) {
      res.add(genreTotalList[_selectedItems[j]]);
    }
    return res;
  }
}
