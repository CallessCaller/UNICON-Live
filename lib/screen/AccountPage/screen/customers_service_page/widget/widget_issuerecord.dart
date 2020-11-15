import 'package:flutter/material.dart';
import 'package:testing_layout/model/issue_report.dart';
import 'package:testing_layout/screen/AccountPage/screen/customers_service_page/widget/widget_issuereceipt.dart';

class IssueRecord extends StatelessWidget {
  final IssueReport issue;
  const IssueRecord({this.issue});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IssueReceipt(),
          ),
        );
      },
      child: ListTile(
        title: Text(
          '${issue.reportDate.toDate().year}.${issue.reportDate.toDate().month}.${issue.reportDate.toDate().day}',
        ),
      ),
    );
  }
}
