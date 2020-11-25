import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/components/feed_functions.dart';

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
    UserDB userDB = Provider.of<UserDB>(context);
    UserDB commentOwner = UserDB.fromSnapshot(snapshot);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(commentOwner.profile),
              radius: 17,
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
                          commentOwner.name.toString(),
                          style: body2,
                        ),
                      ),
                      Container(
                        child: Text(
                          ' ' + showTime(widget.comment.data()['time']),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: outlineColor,
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
                          : InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    barrierDismissible:
                                        true, // user must tap button!

                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              dialogRadius),
                                        ),
                                        backgroundColor: dialogColor1,
                                        title: Center(
                                          child: Text(
                                            "신고",
                                            style: title1,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "부적절한 내용인가요?",
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: FlatButton(
                                                    color: dialogColor3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              widgetRadius),
                                                    ),
                                                    child: Text(
                                                      '아니요',
                                                      style: TextStyle(
                                                        color: dialogColor4,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: FlatButton(
                                                    color: appKeyColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              widgetRadius),
                                                    ),
                                                    child: Text(
                                                      '네',
                                                      style: subtitle3,
                                                    ),
                                                    onPressed: () async {
                                                      if (userDB
                                                              .dislikeComment ==
                                                          null) {
                                                        await userDB.reference
                                                            .update({
                                                          'dislikeComment': []
                                                        });
                                                      }

                                                      int report =
                                                          widget.comment.data()[
                                                                  'report'] +
                                                              1;

                                                      await widget
                                                          .comment.reference
                                                          .update({
                                                        'report': (report)
                                                      });

                                                      userDB.dislikeComment.add(
                                                          widget.comment
                                                              .reference.id);

                                                      await userDB.reference
                                                          .update({
                                                        'dislikeComment': userDB
                                                            .dislikeComment
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                child: Icon(
                                  MdiIcons.alert,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                    ],
                  ),
                  Text(
                    widget.comment.data()['content'],
                    maxLines: 1000,
                    style: body4,
                  ),
                  SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
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
