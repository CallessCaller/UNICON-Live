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
            barrierDismissible: false,
            context: context,
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
                  child: Icon(
                    UniIcon.ticket_price,
                    color: appKeyColor,
                    size: 100,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: subtitle1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: outlineColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appKeyColor,
                          ),
                        ),
                        hintText: userDB.fee != null && userDB.fee == 0
                            ? '현재 입장료: 무료(0코인)'
                            : '현재 입장료: ${userDB.fee} 코인',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FlatButton(
                            minWidth: 110,
                            color: dialogColor3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widgetRadius),
                            ),
                            onPressed: () {
                              controller.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: dialogColor4,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: FlatButton(
                            minWidth: 110,
                            color: appKeyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widgetRadius),
                            ),
                            onPressed: () async {
                              int stringToInt = int.parse(controller.text);
                              userDB.fee = stringToInt;

                              await userDB.reference
                                  .update({'fee': userDB.fee});

                              controller.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '변경',
                              style: subtitle3,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
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
              '공연 입장료',
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
