import 'package:flutter/material.dart';
import 'package:testing_layout/widget/unicoin/widget_unicoin10.dart';

class LabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Unicoin10(),
        ),
      ),
    );
  }
}
