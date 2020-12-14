import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

bool hideChat = true;

List<Widget> chitchat = [
  //실시간으로 받아서 업데이트
  //현 시점으로부터 최대 100개씩만
  //업데이트되면 bottom으로 스크롤
];

Widget nameText(DocumentReference reference, BuildContext context, String name,
    String content, bool gift, bool admin, bool artist, String userID) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: textFontSize - 1,
              color: gift
                  ? appKeyColor.withOpacity(0.8)
                  : admin
                      ? Colors.red.withOpacity(0.8)
                      : Colors.black.withOpacity(0.8)),
          children: [
            TextSpan(
              text: name,
              style: TextStyle(
                  fontSize: textFontSize,
                  color: artist
                      ? appKeyColor
                      : admin
                          ? Colors.red
                          : Colors.black,
                  fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  showDialog(
                      context: context,
                      barrierDismissible: true, // user must tap button!

                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(dialogRadius),
                          ),
                          backgroundColor: dialogColor1,
                          title: Center(
                            child: Text(
                              "신고",
                              style: title1,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "부적절한 내용인가요?",
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: FlatButton(
                                      color: dialogColor3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(widgetRadius),
                                      ),
                                      child: Text(
                                        '아니요',
                                        style: TextStyle(
                                          color: dialogColor4,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: FlatButton(
                                      color: appKeyColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(widgetRadius),
                                      ),
                                      child: Text(
                                        '네',
                                        style: subtitle3,
                                      ),
                                      onPressed: () async {
                                        var chatSnapshot =
                                            await reference.get();
                                        List<dynamic> haters =
                                            await chatSnapshot.data()['haters'];

                                        haters.add(userID);

                                        await reference
                                            .update({'haters': haters});

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
            ),
            TextSpan(text: gift ? content : ': ' + content)
          ],
        ),
      ),
      SizedBox(
        height: 5,
      ),
    ],
  );
}
