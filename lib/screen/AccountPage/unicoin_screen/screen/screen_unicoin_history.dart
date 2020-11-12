import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/coin_transaction.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/widget_coinbox.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/widget_history_header_tile.dart';

class UnicoinHistoryScreen extends StatefulWidget {
  final UserDB userDB;
  final List<CoinTransaction> history;

  const UnicoinHistoryScreen({Key key, this.userDB, this.history})
      : super(key: key);
  @override
  _UnicoinHistoryScreenState createState() => _UnicoinHistoryScreenState();
}

class _UnicoinHistoryScreenState extends State<UnicoinHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.history.length == 0
        ? Center(
            child: Text(
              '사용내역이 없습니다.',
              style: TextStyle(
                fontSize: textFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.65),
              ),
            ),
          )
        : ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            itemCount:
                widget.history.length == 0 ? 1 : widget.history.length + 1,
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
          );
  }
}
