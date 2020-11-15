import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/coin_transaction.dart';

class CoinTransactionDetail extends StatelessWidget {
  final CoinTransaction coinTransaction;

  const CoinTransactionDetail({this.coinTransaction});

  _transactionDetail(val) {
    if (val == 0) {
      return "내역: 이벤트로 인한 유니코인 지급입니다.";
    } else if (val == 1) {
      return "내역: 유니코인을 충전하셨습니다.";
    } else if (val == 2) {
      return "내역: ${coinTransaction.who}님께서 후원해주셨습니다.";
    } else if (val == 3) {
      return "내역: ${coinTransaction.who}님을 후원하셨습니다.";
    } else {
      return "System Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(widgetDefaultPadding),
          color: Colors.white,
          width: 270,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(widgetDefaultPadding),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '유니코인 영수증',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Container(
                width: 270 - 2 * widgetDefaultPadding,
                padding: EdgeInsets.all(widgetDefaultPadding),
                decoration: BoxDecoration(
                  color: appKeyColor,
                  borderRadius: BorderRadius.circular(widgetRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '일시: ${coinTransaction.time.toDate().year}.${coinTransaction.time.toDate().month}.${coinTransaction.time.toDate().day} ${coinTransaction.time.toDate().hour}:${coinTransaction.time.toDate().minute}',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      coinTransaction.type != 3
                          ? '금액: +${coinTransaction.amount.toString()}'
                          : '금액: -${coinTransaction.amount.toString()}',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _transactionDetail(coinTransaction.type),
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
