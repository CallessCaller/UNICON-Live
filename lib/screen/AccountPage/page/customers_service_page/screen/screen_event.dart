import 'package:flutter/material.dart';
import 'package:testing_layout/screen/AccountPage/page/customers_service_page/widget/widget_eventbox.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final List events = ['친구와 함께 보기', '나 혼자 보기', '너나 보렴', '재밌게 보렴', '왜 안 보니?'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text('이벤트'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildEventList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEventList() {
    List<Widget> res = [];
    for (var i = 0; i < events.length; i++) {
      res.add(EventBox(
        name: events[i],
      ));
      res.add(SizedBox(
        height: 40,
      ));
    }
    return res;
  }
}
