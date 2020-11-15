import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/screen/AccountPage/screen/review_page/my_unicon_reviews.dart';

class ToMyUniconReviews extends StatelessWidget {
  const ToMyUniconReviews({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyUniconReviewsPage(),
          ),
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 100) / 4,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review,
              size: 35,
            ),
            SizedBox(height: 10),
            Text(
              '스냅샷 일기',
              style: TextStyle(
                fontSize: widgetFontSize,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
