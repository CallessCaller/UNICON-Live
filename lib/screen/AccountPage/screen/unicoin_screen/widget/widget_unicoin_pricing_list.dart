import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';

const bool _kAutoConsume = true;

const List<String> _kProductIds = <String>[
  'unicon.unicoin10',
  'unicon.unicoin50',
  'unicon.unicoin100',
  'unicon.unicoin500',
  'unicon.unicoin1000',
];

// const List<String> _kProductIds = <String>[
//   'android.test.purchased',
//   'android.test.purchased',
//   'android.test.canceled',
//   'android.test.refunded',
//   'android.test.item_unavailable',
// ];

class UnicoinPricingList extends StatefulWidget {
  final UserDB userDB;
  UnicoinPricingList({this.userDB});

  @override
  _UnicoinPricingListState createState() => _UnicoinPricingListState();
}

class _UnicoinPricingListState extends State<UnicoinPricingList> {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

  @override
  void initState() {
    super.initState();
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userDB.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        return _buildBody(context, snapshot.data);
      },
    );
  }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    UserDB _userDB = UserDB.fromSnapshot(snapshot);

    List<Widget> stack = [];

    if (_queryProductError == null) {
      stack.add(
        Column(
          children: [
            _buildProductList(_userDB),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Center(
          child: CircularProgressIndicator(backgroundColor: Colors.transparent),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(widgetRadius),
      ),
      child: Column(
        children: [
          Text(
            '유니코인 충전',
            style: TextStyle(
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Stack(
            children: stack,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  Widget _buildProductList(UserDB userDB) {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ),
              title: Text('상품을 불러오는 중입니다...'))));
    }
    if (!_isAvailable) {
      return Card();
    }

    List<Widget> productList = [];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.dark().errorColor)),
          subtitle: Text('error')));
    }

    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        return priceTag(userDB, productDetails);
      },
    ));

    return Column(children: productList);
  }

  Widget priceButton(UserDB userdB, ProductDetails productDetails) {
    return FlatButton(
      onPressed: () {
        PurchaseParam purchaseParam = PurchaseParam(
            productDetails: productDetails,
            applicationUserName: null,
            sandboxTesting: true);

        _connection.buyConsumable(
            purchaseParam: purchaseParam,
            autoConsume: _kAutoConsume || Platform.isIOS);
      },
      color: appKeyColor,
      minWidth: 110,
      height: 30,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widgetRadius)),
      child: Text(
        productDetails.price,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: textFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget priceTag(UserDB userDB, ProductDetails productDetails) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: 40,
            alignment: Alignment.centerLeft,
            child: Text(
              productDetails.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: textFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        priceButton(userDB, productDetails),
      ],
    );
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();

    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    // List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      // _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          await InAppPurchaseConnection.instance
              .consumePurchase(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    // print('complete!');
    // await ConsumableStore.save(purchaseDetails.purchaseID);
    // List<String> consumables = await ConsumableStore.load();
    int coinAmount = 0;
    if (purchaseDetails.productID == _kProductIds[0]) {
      coinAmount = 10;
    } else if (purchaseDetails.productID == _kProductIds[1]) {
      coinAmount = 50;
    } else if (purchaseDetails.productID == _kProductIds[2]) {
      coinAmount = 100;
    } else if (purchaseDetails.productID == _kProductIds[3]) {
      coinAmount = 500;
    } else if (purchaseDetails.productID == _kProductIds[4]) {
      coinAmount = 1000;
    }

    DateTime currentTime = DateTime.now();
    await widget.userDB.reference.collection('unicoin_history').add({
      'type': 1,
      'who': 'Y&W Seoul Promotion Inc.',
      'whoseID': 'Y&W Seoul Promotion Inc.',
      'amount': coinAmount,
      'time': currentTime,
    });

    widget.userDB.points += coinAmount;
    await widget.userDB.reference.update({'points': widget.userDB.points});

    setState(() {
      _purchasePending = false;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.

    return Future<bool>.value(true);
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    print(error.message);
    setState(() {
      _purchasePending = false;
    });
  }
}
