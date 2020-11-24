import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/faq_model.dart';

class ExpansionFAQElement {
  bool isExpanded;
  FAQModel faqModel;
  ExpansionFAQElement({this.isExpanded: false, this.faqModel});
}

class FAQWidget extends StatefulWidget {
  const FAQWidget({
    Key key,
  }) : super(key: key);

  @override
  _FAQWidgetState createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  List<FAQModel> faqList;

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('FAQ')
          .orderBy('index', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    faqList = snapshot.map((e) => FAQModel.fromSnapshot(e)).toList();
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: faqList.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Container(
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'FAQ',
                style: subtitle1,
              ),
            ),
          );
        }
        index -= 1;
        return ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          childrenPadding: EdgeInsets.all(widgetDefaultPadding),
          title: Text(
            'Q. ${faqList[index].question}',
            style: subtitle2,
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'A. ${faqList[index].answer}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
