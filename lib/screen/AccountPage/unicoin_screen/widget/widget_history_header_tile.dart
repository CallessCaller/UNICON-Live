import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

class HistoryHeaderTile extends StatelessWidget {
  const HistoryHeaderTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                width: 157,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widgetRadius),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  '날짜',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 157,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widgetRadius),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  '세부내역',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
