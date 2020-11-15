import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/coin_transaction.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/screen/screen_unicoin_history.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/screen/screen_unicoin_home.dart';
import 'package:testing_layout/screen/AccountPage/screen/unicoin_screen/widget/widget_circle_tab_indicator.dart';

class MyUnicoinPage extends StatefulWidget {
  final UserDB userDB;

  const MyUnicoinPage({Key key, this.userDB}) : super(key: key);
  @override
  _MyUnicoinPageState createState() => _MyUnicoinPageState();
}

class _MyUnicoinPageState extends State<MyUnicoinPage> {
  final double _tabBarHeight = 30;
  final double _indicatorHeight = 6;

  List<CoinTransaction> history;
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.userDB.reference
          .collection('unicoin_history')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    history = snapshot.map((e) => CoinTransaction.fromSnapshot(e)).toList();

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize:
                Size(double.infinity, kToolbarHeight + _tabBarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: kToolbarHeight,
                      height: kToolbarHeight,
                    ),
                    Expanded(
                      child: Container(
                        height: kToolbarHeight,
                        child: Center(
                          child: Text(
                            '유니코인',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: kToolbarHeight,
                      height: kToolbarHeight,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: _tabBarHeight,
                    width: MediaQuery.of(context).size.width / 2,
                    child: TabBar(
                        unselectedLabelColor: Colors.white.withOpacity(0.65),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: CircleTabIndicator(
                          color: appKeyColor,
                          radius: _indicatorHeight / 2,
                        ),
                        tabs: [
                          Tab(
                            child: Container(
                              height: kToolbarHeight,
                              child: Center(
                                child: Text(
                                  '홈',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: kToolbarHeight,
                              child: Center(
                                child: Text(
                                  '사용내역',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Tab(
                          //   child: Container(
                          //     height: kToolbarHeight,
                          //     child: Center(
                          //       child: Text('설정'),
                          //     ),
                          //   ),
                          // ),
                        ]),
                  ),
                )
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                UnicoinHomeScreen(userDB: widget.userDB, history: history),
                UnicoinHistoryScreen(userDB: widget.userDB, history: history),
                // UnicoinSettings(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
