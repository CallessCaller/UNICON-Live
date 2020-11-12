import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/feed_functions.dart';

class CommentBox extends StatefulWidget {
  final String ownerId;
  final DocumentSnapshot comment;
  final String userId;
  CommentBox({this.comment, this.userId, this.ownerId});
  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.comment.data()['id'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return _buildBody(context, snapshot.data);
        });
  }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    UserDB userDB = UserDB.fromSnapshot(snapshot);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userDB.profile),
              radius: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          '${userDB.name} - ' +
                              showTime(widget.comment.data()['time']),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: textFontSize,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      (widget.userId == widget.ownerId ||
                              widget.userId == widget.comment.data()['id'])
                          ? InkWell(
                              onTap: () async {
                                showAlertDialog(context);
                              },
                              child: Container(
                                child: Icon(
                                  MdiIcons.delete,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                  Text(
                    widget.comment.data()['content'],
                    maxLines: 1000,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.white,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              //side: BorderSide(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(11)),
          backgroundColor: Colors.black,
          content: Text(
            "정말 삭제하시겠습니까?",
            style: TextStyle(fontSize: textFontSize),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '삭제',
                style: TextStyle(fontSize: textFontSize),
              ),
              onPressed: () async {
                await widget.comment.reference.delete();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '취소',
                style: TextStyle(fontSize: textFontSize),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
