import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramLinkBox extends StatefulWidget {
  final String instagramID;
  const InstagramLinkBox({Key key, this.instagramID}) : super(key: key);
  @override
  _InstagramLinkBoxState createState() => _InstagramLinkBoxState();
}

class _InstagramLinkBoxState extends State<InstagramLinkBox> {
  _showMessage(BuildContext context) {
    var _alertDialog = AlertDialog(
      title: Text(
        '해당 유니온이 기입을 완료하지 않았습니다.',
        style: TextStyle(fontSize: textFontSize, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => _alertDialog,
    );
  }

  _launchInstagram(BuildContext context, String instagramID) async {
    if (instagramID == null || instagramID == '') {
      _showMessage(context);
      return;
    }
    String instagramUrl = 'https://instagram.com/' + instagramID;
    if (await canLaunch(instagramUrl)) {
      await launch(
        instagramUrl,
        forceWebView: true,
        forceSafariVC: true,
        enableJavaScript: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      print('Error');
      throw 'Could not launch $instagramUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        UniIcon.instagram,
        size: 35,
      ),
      onPressed: () {
        _launchInstagram(context, widget.instagramID);
      },
    );
  }
}
