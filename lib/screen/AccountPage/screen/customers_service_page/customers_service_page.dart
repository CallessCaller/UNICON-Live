import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/customers_service_page/widget/widget_dialog.dart';
import 'package:testing_layout/screen/AccountPage/screen/customers_service_page/widget/widget_faq.dart';

class CSPage extends StatefulWidget {
  final UserDB userDB;
  const CSPage({this.userDB});
  @override
  _CSPageState createState() => _CSPageState();
}

class _CSPageState extends State<CSPage> {
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (250 - kToolbarHeight);
  }

  _showFullScreenDialog(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => DialogWidget(
          userDB: widget.userDB,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250,
              floating: false,
              pinned: true,
              centerTitle: false,
              title: Text(
                '고객센터',
                style: TextStyle(
                  color: isShrink ? Colors.white : Colors.transparent,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: customerServiceBanner,
                  imageBuilder: (context, imageProvider) => Container(
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              FAQWidget(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '문의하기',
                          style: subtitle1,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showFullScreenDialog(context);
                      },
                      child: Container(
                        height: 40,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '문의하기',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
