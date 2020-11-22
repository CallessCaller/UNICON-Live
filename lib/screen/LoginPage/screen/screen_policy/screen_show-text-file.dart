import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_layout/components/constant.dart';

class ShowTextFileScreen extends StatefulWidget {
  final String filename;
  final String title;
  const ShowTextFileScreen({this.filename, this.title});

  @override
  _ShowTextFileScreenState createState() => _ShowTextFileScreenState();
}

class _ShowTextFileScreenState extends State<ShowTextFileScreen> {
  String data = '';
  fetchFileData() async {
    String responseText;
    responseText =
        await rootBundle.loadString('assets/policy-text/' + widget.filename);
    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.title,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Text(
            data,
            style: body4,
          ),
        ),
      ),
    );
  }
}
