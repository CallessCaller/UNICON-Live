import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/webConstant.dart';

class OnlyChat extends StatefulWidget {
  final Lives live;
  OnlyChat({this.live});
  @override
  _OnlyChatState createState() => _OnlyChatState();
}

class _OnlyChatState extends State<OnlyChat> {
  final ScrollController scrollController = new ScrollController();
  Stream<DocumentSnapshot> documentStream;
  List<dynamic> viewers = [];
  StreamSubscription<DocumentSnapshot> stream;

  @override
  void initState() {
    super.initState();
    documentStream = FirebaseFirestore.instance
        .collection('LiveTmp')
        .doc(widget.live.id)
        .snapshots(includeMetadataChanges: true);

    stream = documentStream.listen((event) {
      setState(() {
        viewers = event.data()['viewers'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
  }

  List<Widget> results;
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.live.reference
          .collection('chitchat')
          .orderBy('time', descending: true)
          .limit(40)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    results = snapshot
        .map((d) =>
            nameText(d.data()['name'], d.data()['content'], d.data()['gift']))
        .toList()
        .reversed
        .toList();

    if (results.length == 0) {
      results.add(nameText('UniCon', '방송이 시작되었습니다.', false));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Row(
            children: [
              Icon(Icons.people),
              Text(
                '   ' + (viewers.length).toString() + '   ',
                style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(50, 5, 20, 5),
        height: _height,
        width: _width,
        color: Colors.transparent,
        child: ListView(
          controller: scrollController,
          children: results,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
