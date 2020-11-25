import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/coin_transaction.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/widget/widget_reciept_dialog.dart';

class CoinRecordBox extends StatelessWidget {
  final CoinTransaction coinTransaction;

  const CoinRecordBox({Key key, this.coinTransaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CoinTransactionDetail(
              coinTransaction: coinTransaction,
            ),
          ),
        );
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 30,
              width: 157,
              alignment: Alignment.center,
              child: Text(
                '${coinTransaction.time.toDate().year}.${coinTransaction.time.toDate().month}.${coinTransaction.time.toDate().day}',
                style: TextStyle(
                  fontSize: textFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 30,
              width: 157,
              alignment: Alignment.center,
              child: Text(
                coinTransaction.type != 3
                    ? '+${coinTransaction.amount.toString()}'
                    : '-${coinTransaction.amount.toString()}',
                style: TextStyle(
                  fontSize: textFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
