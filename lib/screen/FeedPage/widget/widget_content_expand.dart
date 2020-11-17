import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

class ContentExpandWidget extends StatefulWidget {
  final String text;

  ContentExpandWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<ContentExpandWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      // padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? Text(firstHalf)
          : Column(
              children: <Widget>[
                Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        flag ? "더보기" : "줄이기",
                        style: new TextStyle(
                          color: outlineColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                  ),
                )
              ],
            ),
    );
  }
}
