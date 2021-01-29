import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/providers/stream_of_user.dart';

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
    final userDB = Provider.of<UserDB>(context);
    final records = Provider.of<List<Records>>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            //size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 40,
        centerTitle: false,
        title: Text('VIDEO', style: headline2),
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            //Navigator.of(context).pushReplacement(child:RecordPage());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StreamProvider.value(
                    value: StreamOfuser().getUser(userDB.id),
                    child: RecordPage()),
              ),
            );
          });
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
