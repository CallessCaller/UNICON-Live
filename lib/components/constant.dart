import 'package:flutter/material.dart';

// document links
const String privacyPolicyUrl = "https://www.unicon.show/privacy-policy";
const String openSourceDocUrl = 'https://www.unicon.show/open-source-license';

// screen, widget related properties
const double defaultPadding = 20.0;
const double widgetDefaultPadding = 10.0;
const double widgetRadius = 7.0;
const double dialogRadius = 11.0;

// main colors used in unicon
const Color appKeyColor = Color(0xffb63af0);
const Color appBarColor = Color(0xff1a1a1a);
const Color outlineColor = Color(0xffa3a3a3);

// colors for dialog
const Color dialogColor1 = Color(0xff1b1b1c);
const Color dialogColor2 = Color(0xff484849);
const Color dialogColor3 = Color(0xff545455);
const Color dialogColor4 = Color(0xffff3b30);

const double titleFontSize = 36.0;
const double subtitleFontSize = 16.0;
const double textFontSize = 14.0;
const double widgetFontSize = 12.0;

// App walkthrough related properties
const List<String> iosGuideImage = [
  'assets/walkthrough/ios_1.png',
  'assets/walkthrough/ios_2.png',
  'assets/walkthrough/ios_3.png',
  'assets/walkthrough/ios_4.png',
];
const List<String> aosGuideImage = [
  'assets/walkthrough/aos_1.png',
  'assets/walkthrough/aos_2.png',
  'assets/walkthrough/aos_3.png',
  'assets/walkthrough/aos_4.png',
];

// Banner images URL
const String requestUnionBanner =
    "https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/banner_images%2Frequest_union.png?alt=media&token=cafe7dda-317d-4790-b782-e8e8b1f60939";
const String customerServiceBanner =
    "https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/banner_images%2Fcustomer_service.png?alt=media&token=df0763a6-9f8e-429f-8f06-6d7e97f4e1ed";

// genre and mood in unicon
const List<String> genreTotalList = [
  'Hip-Hop',
  'Rock',
  'R&B',
  'Jazz',
  'Pop',
  'New Age',
  'EDM',
  'Ballad',
];
const List<String> moodTotalList = [
  '#로맨틱한',
  '#신나는',
  '#밝은',
  '#잔잔한',
  '#우울한날',
  '#기분전환',
  '#그루비한',
  '#몽환적인',
  '#레트로',
];

// genre and mood images in unicon
List<String> genrePictures = [
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2Fhiphop_crop.jpg?alt=media&token=c38e1bee-aa77-49a4-af18-4b90970e6375',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2Frock_crop.jpg?alt=media&token=18284ee0-22ce-42ed-b116-00a128361bdc',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2FR%26B_crop.jpg?alt=media&token=ddbfb642-caca-4f61-9001-fd019934e25d',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2Fjazz_crop.jpg?alt=media&token=6b01b3eb-28de-4b1b-840f-34e509f6cd81',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2FPOP_crop.jpg?alt=media&token=d09d97db-69b4-4292-8b23-6510239b2aa8',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2Fnew%20age_crop.jpg?alt=media&token=e7d59c42-106e-45bd-9226-ce896227c071',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2FEDM_crop.jpg?alt=media&token=b430ef0a-bda3-49c4-aff8-80c1244e5ec6',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2FBALLAD_crop.jpg?alt=media&token=84526985-8d79-4450-8e89-29ea1696b6fd',
];
List<String> moodPictures = [
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EB%A1%9C%EB%A9%98%ED%8B%B1%40300x_crop.jpg?alt=media&token=66bb670d-2f53-4141-bbf5-8721641bd42c',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EC%8B%A0%EB%82%98%EB%8A%94%40300x_crop.jpg?alt=media&token=006b48d5-3fdc-4b46-8a7c-230d4808dc93',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EB%B0%9D%EC%9D%80%40300x_crop.jpg?alt=media&token=1177a2de-34c7-4226-900f-72f6d0b36cfe',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EC%B0%A8%EB%B6%84%ED%95%9C%40300x_crop.jpg?alt=media&token=960cef68-5d2d-4abc-82ca-d9e1e6049741',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EC%9A%B0%EC%9A%B8%ED%95%9C%EB%82%A0%40300x_crop.jpg?alt=media&token=fc37e1a6-364f-4834-a6e1-292459b87c7b',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EA%B8%B0%EB%B6%84%EC%A0%84%ED%99%98%40300x_crop.jpg?alt=media&token=45463b9c-59ef-4b1b-a434-f268e840e323',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EA%B7%B8%EB%A3%A8%EB%B9%84%ED%95%9C%40300x_crop.jpg?alt=media&token=d44a40d5-4342-40d6-8731-d8bd60e612af',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EB%AA%BD%ED%99%98%EC%A0%81%EC%9D%B8%40300x_crop.jpg?alt=media&token=9c674346-f0d3-4b1f-a010-c76b8001b118',
  'https://firebasestorage.googleapis.com/v0/b/testinglayout-7eb1f.appspot.com/o/search_page%2F%EB%A0%88%ED%8A%B8%EB%A1%9C%40300x_crop.jpg?alt=media&token=eaf090fd-5344-407f-994d-b6ba8c28411a',
];

// TextStyles used in Unicon
TextStyle headline1 = TextStyle(
  color: Colors.white,
  fontSize: 30,
  fontWeight: FontWeight.w800,
);

TextStyle headline2 = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.w800,
);

TextStyle title1 = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

TextStyle title2 = TextStyle(
  color: Colors.white,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

TextStyle title3 = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

TextStyle subtitle1 = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle subtitle2 = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle subtitle3 = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

TextStyle body1 = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

TextStyle body2 = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle body3 = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

TextStyle body4 = TextStyle(
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

TextStyle caption1 = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w300,
);

TextStyle caption2 = TextStyle(
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.w300,
);
