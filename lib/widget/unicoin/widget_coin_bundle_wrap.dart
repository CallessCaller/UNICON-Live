import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin10.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin100.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin1000.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin50.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin500.dart';

class CoinBundle extends StatelessWidget {
  const CoinBundle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: outlineColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Unicoin10(),
            onTap: () {},
          ),
          InkWell(
            child: Unicoin50(),
            onTap: () {},
          ),
          InkWell(
            child: Unicoin100(),
            onTap: () {},
          ),
          InkWell(
            child: Unicoin500(),
            onTap: () {},
          ),
          InkWell(
            child: Unicoin1000(),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
