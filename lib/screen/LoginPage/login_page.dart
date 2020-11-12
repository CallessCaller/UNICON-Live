import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/load_user_db.dart';
import 'package:testing_layout/screen/LoginPage/artist_or_user.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 1.2,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/slogan_02.png'),
                        fit: BoxFit.contain),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    showAlertDialog(context);
                    auth.UserCredential userCredential =
                        await signInWithGoogle();
                    if (userCredential.user.uid == _auth.currentUser.uid) {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(_auth.currentUser.uid)
                          .get()
                          .then((value) {
                        if (value.exists == false) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArtistOrUser()));
                          LoadUser().onCreate();
                          // _saveFirst();
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/inapp', (Route<dynamic> route) => false);
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/Google_Logo.png'))),
                        ),
                        Expanded(
                          child: Text(
                            '  구글 로그인',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: subtitleFontSize),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  onPressed: () async {
                    showAlertDialog(context);
                    auth.UserCredential userCredential = await kakaoSignIn();
                    if (userCredential.user.uid == _auth.currentUser.uid) {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(_auth.currentUser.uid)
                          .get()
                          .then((value) {
                        if (value.exists == false) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArtistOrUser()));
                          LoadUser().onCreate();
                          // _saveFirst();
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/inapp', (Route<dynamic> route) => false);
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(254, 229, 0, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/Kakao_Logo.png'))),
                        ),
                        Expanded(
                          child: Text(
                            '카카오 로그인',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: subtitleFontSize),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(seconds: 10), () {});
}

Future<auth.UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final auth.GoogleAuthCredential credential =
      auth.GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await auth.FirebaseAuth.instance.signInWithCredential(credential);
}

void signOutGoogle(BuildContext context) async {
  await googleSignIn.signOut();
  // Call back when user sign out
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  print("User Sign Out");
}

Future<auth.UserCredential> kakaoSignIn() async {
  try {
    final String token = await _retrieveToken();
    final authResult =
        await _auth.signInWithCustomToken(await _verifyToken(token));

    final auth.User firebaseUser = authResult.user;
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    print(currentUser.uid);
    assert(firebaseUser.uid == currentUser.uid);

    await _updateEmailInfo(firebaseUser);

    return authResult;
  } on KakaoAuthException catch (e) {
    return Future.error(e);
  } on KakaoClientException catch (e) {
    return Future.error(e);
  } catch (e) {
    if (e.toString().contains("already in use")) {
      return Future.error(PlatformException(
          code: "ERROR_EMAIL_ALREADY_IN_USE",
          message: "The email address is already in use by another account"));
    }
    return Future.error(e);
  }
}

Future<String> _retrieveToken() async {
  final installed = await isKakaoTalkInstalled();
  final authCode = installed
      ? await AuthCodeClient.instance.requestWithTalk()
      : await AuthCodeClient.instance.request();
  AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);

  await AccessTokenStore.instance.toStore(
      token); // Store access token in AccessTokenStore for future API requests.
  return token.accessToken;
}

Future<void> _updateEmailInfo(auth.User firebaseUser) async {
  // When sign in is done, update email info.
  User kakaoUser = await UserApi.instance.me();
  if (kakaoUser.kakaoAccount.email.isNotEmpty) {
    firebaseUser.updateEmail(kakaoUser.kakaoAccount.email);
  }
}

Future<String> _verifyToken(String kakaoToken) async {
  try {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('verifyKakaoToken');

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'token': kakaoToken,
      },
    );

    if (result.data['error'] != null) {
      print(result.data['error']);
      return Future.error(result.data['error']);
    } else {
      return result.data['token'];
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<void> kakaoSignOut(BuildContext context) {
  AccessTokenStore.instance.clear();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  print("User Sign Out");
  return Future.value("");
}

Future<auth.User> linkWith(auth.User user) async {
  try {
    final token = await _retrieveToken();

    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('linkWithKakao');

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'token': token,
      },
    );

    if (result.data['error'] != null) {
      return Future.error(result.data['error']);
    } else {
      auth.User user = _auth.currentUser;

      // Update email info if possible.
      await _updateEmailInfo(user);

      return user;
    }
  } on KakaoAuthException catch (e) {
    return Future.error(e);
  } on KakaoClientException catch (e) {
    return Future.error(e);
  } catch (e) {
    return Future.error(e);
  }
}
