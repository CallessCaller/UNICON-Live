import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/constant.dart';
import '../../../model/records.dart';
import '../widget/record_box.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    final records = Provider.of<List<Records>>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: false,
        title: Text('VIDEO', style: headline2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
        },
        child: ListView(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Text('', style: subtitle1),
                      SizedBox(
                        height: 0,
                      ),
                    ] +
                    currentRecords(records),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  List<Widget> currentRecords(List<Records> records) {
    List<Widget> result = [];
    for (int i = records.length - 1; i > -1; i--) {
      result.add(RecordBox(record: records[i]));
      result.add(Divider(
        height: 20,
        color: Colors.transparent,
      ));
    }
    return result;
  }
}
