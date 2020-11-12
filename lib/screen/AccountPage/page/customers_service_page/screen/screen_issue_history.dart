import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/model/issue_report.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/page/customers_service_page/widget/widget_issuerecord.dart';

class IssueHistoryScreen extends StatefulWidget {
  final UserDB userDB;

  const IssueHistoryScreen({Key key, this.userDB}) : super(key: key);
  @override
  _IssueHistoryScreenState createState() => _IssueHistoryScreenState();
}

class _IssueHistoryScreenState extends State<IssueHistoryScreen> {
  List<IssueReport> history;
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.userDB.reference
          .collection('my_issues')
          .orderBy('report_date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    history = snapshot.map((e) => IssueReport.fromSnapshot(e)).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text('나의 문의현황'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          if (history.length == 0) {
            return Center(
              child: Text('접수된 문의사항이 없습니다.'),
            );
          } else {
            return IssueRecord(issue: history[index]);
          }
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
