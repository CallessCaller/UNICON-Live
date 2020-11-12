import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/unicoin_screen/widget/widget_unicoin_abstract_box.dart';

class PayModule extends StatefulWidget {
  final UserDB userDB;
  final int coinAmount;

  PayModule({this.userDB, this.coinAmount});
  @override
  _PayModuleState createState() => _PayModuleState();
}

class _PayModuleState extends State<PayModule> {
  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: new AppBar(
        title: new Text(
          '유니코인 결제',
          style: TextStyle(
              fontSize: subtitleFontSize, fontWeight: FontWeight.bold),
        ),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: Text('잠시만 기다려주세요...',
                style: TextStyle(fontSize: subtitleFontSize)),
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'imp92876611',
      /* [필수입력] 결제 데이터 */
      data: PaymentData.fromJson({
        'pg': 'kakaopay', // PG사
        'payMethod': 'card', // 결제수단
        'name': '유니코인', // 주문명
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        'amount': getPrice(widget.coinAmount.toString()), // 결제금액
        'buyerName': widget.userDB.name, // 구매자 이름
        'buyerTel': '', // 구매자 연락처
        'buyerEmail': widget.userDB.email, // 구매자 이메일
        'buyerAddr': '서울특별시 강남구 테헤란로64길 13', // 구매자 주소
        'buyerPostcode': '06193', // 구매자 우편번호
        'appScheme': 'johntopia.toyproject.testing_layout', // 앱 URL scheme
        'display': {
          'cardQuota': [2, 3] //결제창 UI 내 할부개월수 제한
        }
      }),
      /* [필수입력] 콜백 함수 */
      // TODO: 결제 정보 확인, 이 프로세스가 맞나 확인
      callback: (Map<String, String> result) async {
        DateTime currentTime = DateTime.now();
        await widget.userDB.reference.collection('unicoin_history').add({
          'type': 1,
          'who': 'Y&W Seoul Promotion Inc.',
          'whoseID': 'Y&W Seoul Promotion Inc.',
          'amount': widget.coinAmount,
          'time': currentTime,
        });

        if (result['imp_success'].toString() == 'true') {
          widget.userDB.points += widget.coinAmount;
          await widget.userDB.reference
              .update({'points': widget.userDB.points});
        }
        Navigator.of(context).pop();
      },
    );
  }
}
