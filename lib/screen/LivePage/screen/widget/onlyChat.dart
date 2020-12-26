import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/screen/LivePage/screen/widget/webConstant.dart';

// TODO: 라이브 시청자 수 새 필드 생성
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
        .map((d) {
          List<dynamic> haters = d.data()['haters'];
          if (haters.contains(widget.live.id)) {
            return SizedBox();
          }

          return nameText(
              d.reference,
              context,
              d.data()['name'],
              d.data()['content'],
              d.data()['gift'],
              d.data()['admin'] ?? false,
              d.data()['is_artist'] ?? false,
              widget.live.id);
        })
        .toList()
        .reversed
        .toList();

    if (results.length == 0) {
      results.add(nameText(
          null, context, 'UniCon', '방송이 시작되었습니다.', false, true, false, ''));
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Row(
            children: [
              Icon(
                Icons.people,
                color: Colors.black,
              ),
              Text(
                '   ' + (viewers.length).toString() + '   ',
                style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
