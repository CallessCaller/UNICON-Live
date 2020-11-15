import 'package:flutter/material.dart';
import 'package:testing_layout/screen/AccountPage/screen/review_page/widget/review_box.dart';

class Review {
  DateTime date;
  String image;
  String content;

  Review(DateTime date, String image, String content) {
    this.date = date;
    this.image = image;
    this.content = content;
  }
}

List<Review> reviews = [
  Review(DateTime(2020, 10, 15), 'assets/unicon_logo1.png', "1"),
  Review(DateTime(2020, 10, 16), 'assets/unicon_logo1.png', "2"),
  Review(DateTime(2020, 10, 17), 'assets/unicon_logo1.png', "3"),
  Review(DateTime(2020, 10, 18), 'assets/unicon_logo1.png', "4"),
  Review(DateTime(2020, 10, 18), 'assets/profilepic.jpg', "5"),
  Review(DateTime(2020, 10, 20), 'assets/unicon_logo1.png', "6"),
  Review(DateTime(2020, 10, 21), 'assets/unicon_logo1.png', "7"),
  Review(DateTime(2020, 10, 22), 'assets/unicon_logo1.png', "8"),
  Review(DateTime(2020, 10, 23), 'assets/unicon_logo1.png', "9"),
  Review(DateTime(2020, 10, 24), 'assets/unicon_logo1.png', "10"),
  Review(DateTime(2020, 10, 25), 'assets/profilepic.jpg', "11"),
  Review(DateTime(2020, 10, 25), 'assets/unicon_logo1.png', "12"),
  Review(DateTime(2020, 10, 26), 'assets/unicon_logo1.png', "13"),
  Review(DateTime(2020, 10, 27), 'assets/unicon_logo1.png', "14"),
  Review(DateTime(2020, 10, 28), 'assets/unicon_logo1.png', "15"),
];

class MyUniconReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('스냅샷 일기'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            itemCount: reviews.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 16 / 9,
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ReviewBox(
                review: reviews[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
