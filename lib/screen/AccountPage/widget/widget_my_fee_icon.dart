import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';

class MyFee extends StatelessWidget {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserDB userDB = Provider.of<UserDB>(context);
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11)),
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userDB.fee != null && userDB.fee == 0
                          ? '현재 입장료: 무료(0코인)'
                          : '현재 입장료: ${userDB.fee} 코인',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 100,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: textFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(),
                          border: UnderlineInputBorder(),
                          labelText: '새 입장료(코인)',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: textFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '취소',
                      style: TextStyle(
                          fontSize: textFontSize, color: Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      int stringToInt = int.parse(controller.text);
                      userDB.fee = stringToInt;

                      await userDB.reference.update({'fee': userDB.fee});

                      controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '변경',
                      style:
                          TextStyle(fontSize: textFontSize, color: appKeyColor),
                    ),
                  ),
                ],
              );
            });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 100) / 4,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UniIcon.ticket_price,
              size: 45,
            ),
            SizedBox(height: 10),
            Text(
              '나의 입장료',
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
