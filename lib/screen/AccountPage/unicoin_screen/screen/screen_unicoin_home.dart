import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/coin_transaction.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/widget_coinbox.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/widget_history_header_tile.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/widget_unicoin_abstract_box.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/widget_unicoin_pricing_list.dart';

class UnicoinHomeScreen extends StatefulWidget {
  final UserDB userDB;
  final List<CoinTransaction> history;

  const UnicoinHomeScreen({Key key, this.userDB, this.history})
      : super(key: key);

  @override
  _UnicoinHomeScreenState createState() => _UnicoinHomeScreenState();
}

class _UnicoinHomeScreenState extends State<UnicoinHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          children: [
            UnicoinAbstractBox(
              userDB: widget.userDB,
            ),
            SizedBox(
              height: 33,
            ),
            UnicoinPricingList(
              userDB: widget.userDB,
            ),
            SizedBox(
              height: 33,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                '최근 사용내역',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
            widget.history.length == 0
                ? Center(
                    child: Text(
                      '최근 사용내역이 없습니다.',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 430,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.history.length >= 10
                          ? 11
                          : widget.history.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return HistoryHeaderTile();
                        }
                        index -= 1;
                        return CoinRecordBox(
                          coinTransaction: widget.history[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
