import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          '알림',
          style: headline2,
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.red,
                ),
                VerticalDivider(),
                Text(
                  '내용--------------------------------',
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.red,
                ),
                VerticalDivider(),
                Text(
                  '내용--------------------------------',
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          Divider(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
