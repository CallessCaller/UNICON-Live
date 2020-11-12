import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:testing_layout/screen/AccountPage/review_page/my_unicon_reviews.dart';

String text = 'https://www.instagram.com/unicon_kr/';
String subject = 'Follow us on instagram';

class ReviewDetailPage extends StatefulWidget {
  final Review review;

  const ReviewDetailPage({Key key, this.review}) : super(key: key);

  @override
  _ReviewDetailPageState createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    Intl.defaultLocale = 'ko_KO';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(DateFormat("yyyy년 M월 d일").format(widget.review.date)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Image.asset(
            widget.review.image,
            fit: BoxFit.fitWidth,
          ),
          Center(
            child: Text(
              widget.review.content,
            ),
          )
        ],
      ),
    );
  }
}
