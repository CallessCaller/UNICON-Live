import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/load_user_db.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_artist_or_user.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_policy/screen_show-text-file.dart';

class PolicyCheckDialog extends StatefulWidget {
  @override
  _PolicyCheckDialogState createState() => _PolicyCheckDialogState();
}

class _PolicyCheckDialogState extends State<PolicyCheckDialog> {
  FToast fToast;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  bool check_total = false;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogRadius),
      ),
      backgroundColor: dialogColor1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '약관 동의',
              style: title1,
            ),
          ),
          InkWell(
            child: Icon(
              Icons.close,
              color: dialogColor3,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: check_total,
                  onChanged: (value) {
                    setState(() {
                      check1 = value;
                      check2 = value;
                      check3 = value;
                      check4 = value;
                      check_total = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '전체 동의',
                  style: subtitle1,
                )),
              ],
            ),
            Divider(
              height: 20,
              color: dialogColor3,
              thickness: 2,
            ),
            Row(
              children: [
                Checkbox(
                    value: check1,
                    onChanged: (value) {
                      setState(() {
                        check1 = value;
                      });
                    }),
                Expanded(
                    child: Text(
                  '서비스 이용약관',
                  style: subtitle1,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'terms-and-conditions.txt',
                          title: '서비스 이용약관',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: check2,
                  onChanged: (value) {
                    setState(() {
                      check2 = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '개인정보 처리방침',
                  style: subtitle1,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'privacy-policy.txt',
                          title: '개인정보 처리방침',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: check3,
                  onChanged: (value) {
                    setState(() {
                      check3 = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '커뮤니티 가이드라인',
                  style: subtitle1,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'community-guideline.txt',
                          title: '커뮤니티 가이드라인',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: check4,
                  onChanged: (value) {
                    setState(() {
                      check4 = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '법적고지',
                  style: subtitle1,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'legal-notice.txt',
                          title: '법적고지',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: appKeyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widgetRadius),
                    ),
                    onPressed: () {
                      if (check1 && check2 && check3 && check4) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArtistOrUser()));
                        LoadUser().onCreate();
                      } else {
                        Widget toast = Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: dialogColor1,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning),
                              SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                "약관에 모두 동의하셔야 진행할 수 있습니다.",
                                textAlign: TextAlign.center,
                                style: caption2,
                              ),
                            ],
                          ),
                        );

                        fToast.showToast(
                          child: toast,
                          gravity: ToastGravity.CENTER,
                          toastDuration: Duration(seconds: 2),
                        );
                      }
                    },
                    child: Text(
                      '계속',
                      style: subtitle2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
