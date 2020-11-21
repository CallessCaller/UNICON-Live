import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/model_event.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<EventModel> eventList;

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Events')
          .orderBy('post_time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    eventList = snapshot.map((e) => EventModel.fromSnapshot(e)).toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '이벤트',
          style: headline2,
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        shrinkWrap: true,
        itemCount: eventList.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            tilePadding: EdgeInsets.all(0),
            childrenPadding: EdgeInsets.all(widgetDefaultPadding),
            title: Text(
              eventList[index].name,
              style: subtitle1,
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  eventList[index].content,
                  style: body2,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '게시일자: ${eventList[index].postTime.toDate().year}.${eventList[index].postTime.toDate().month}.${eventList[index].postTime.toDate().day}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                child: Image.network(
                  eventList[index].image,
                  fit: BoxFit.cover,
                ),
              ),
            ],
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
