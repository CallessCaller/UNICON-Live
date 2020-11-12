import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/AccountPage/review_page/my_unicon_reviews.dart';
import 'package:testing_layout/screen/AccountPage/review_page/review_detail_page.dart';

class ReviewBox extends StatefulWidget {
  final Review review;

  const ReviewBox({
    Key key,
    this.review,
  }) : super(key: key);

  @override
  _ReviewBoxState createState() => _ReviewBoxState();
}

class _ReviewBoxState extends State<ReviewBox> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    Intl.defaultLocale = 'ko_KO';
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat("yyyy년 M월 d일").format(widget.review.date);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReviewDetailPage(
              review: widget.review,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Colors.white,
              ),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
                image: AssetImage(widget.review.image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(widgetRadius),
            ),
            child: Center(
              child: Text(
                dateString,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              child: Icon(
                Icons.share,
                size: 17,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
