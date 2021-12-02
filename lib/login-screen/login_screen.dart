import 'package:clicksandstories/database/user_database.dart';
import 'package:clicksandstories/feed-screen/feed_screen.dart';
import 'package:clicksandstories/google_signin_api.dart';
import 'package:clicksandstories/models/user.dart' as db;
import 'package:clicksandstories/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int counter = 0;
  int buttonPress = 1;
  bool isLoading = true;
  late List<db.User> user;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future _handleLogin() async {
    FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    print(_result.errorMessage);
    switch (_result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Login cancelled by user!");
        break;
      case FacebookLoginStatus.error:
        print("Login Error!");
        break;
      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(_result);
        break;
      default:
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _accessToken = _result.accessToken;
    AuthCredential _credential = FacebookAuthProvider.credential(_accessToken.token);
    var a = await _auth.signInWithCredential(_credential);
    print(a);
    setState(() {
      isLoading = true;
    });
    getData(a.user?.displayName, a.user?.email, a.additionalUserInfo?.profile?["picture"]["data"]["url"], a.additionalUserInfo?.profile?["id"], "facebook");
  }

  final oauthDecoration = BoxDecoration(
      color: Colors.white,
      // color: Color.fromRGBO(239, 238, 238, 1),
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(255, 255, 255, 0.5),
          blurRadius: 6.0,
          offset: Offset(-4, -4),
        ),
        BoxShadow(
          color: Color.fromRGBO(209, 205, 199, 0.5),
          blurRadius: 7.0,
          offset: Offset(3, 3),
        ),
      ]);

  final oauthOnTapDecoration = BoxDecoration(
      color: Colors.white,
      // color: Color.fromRGBO(239, 238, 238, 1),
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(255, 255, 255, 0.5),
          blurRadius: 7.0,
          offset: Offset(3, 3),
        ),
        BoxShadow(
          color: Color.fromRGBO(209, 205, 199, 0.5),
          blurRadius: 6.0,
          offset: Offset(-4, -4),
        ),
      ]);

  Future getData(String? username, String? email, String? pictureAddress, String? typeId, String type) async {
    final String url = "https://clicks-and-stories.herokuapp.com/auth/post"; ////phone: 192.168.128.196, ethernet:192.168.31.118
    final response = await http.post(
      Uri.parse(url),
      body: {
        "username": username,
        "email": email,
        "photo": pictureAddress,
        "type": type,
        "typeId": typeId,
      },
    );
    print(response.body);
    final user = db.User(name: username, email: email, photo: pictureAddress, type: type);
    await UserDatabase.instance.create(user);

    Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
  }

  Future signIn(BuildContext context) async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in Failed")));
    } else {
      setState(() {
        isLoading = true;
      });
      print(user.displayName);
      print(user.email);
      print(user.id);
      print(user.photoUrl);
      getData(user.displayName!, user.email, user.photoUrl, user.id, "google");
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    this.user = await UserDatabase.instance.readAllUsers();
    if (!this.user.isEmpty && counter == 1) {
      Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    counter++;
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(133, 157, 218, 0.58),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 0.26 * c),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Clicks",
                                  style: TextStyle(fontFamily: "Conquest", fontSize: 0.182 * c),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 0.364 * c),
                                child: Text(
                                  "&",
                                  style: TextStyle(fontFamily: "Conquest", fontSize: 0.182 * c),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 0.338 * c),
                                child: Text(
                                  "Stories",
                                  style: TextStyle(fontFamily: "Conquest", fontSize: 0.182 * c),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0.052 * c),
                        child: Text(
                          "Explore the world behind the lens",
                          style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0468 * c, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0.13 * c),
                        child: Text(
                          "Login / Signup",
                          style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0468 * c, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0.052 * c),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              buttonPress = 2;
                            });
                          },
                          onTapUp: (_) {
                            signIn(context);
                            setState(() {
                              buttonPress = 1;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              buttonPress = 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
                            height: 0.104 * c,
                            width: 0.39 * c,
                            decoration: buttonPress == 2
                                ? oauthOnTapDecoration
                                : buttonPress == 1
                                    ? oauthDecoration
                                    : oauthDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 0.078 * c,
                                  child: Image.asset(
                                    "assets/images/google.png",
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 0.013 * c),
                                  child: Text(
                                    "Google",
                                    style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0468 * c, color: Color.fromRGBO(174, 174, 174, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              buttonPress = 4;
                            });
                          },
                          onTapUp: (_) async {
                            //signIn(context);
                            //signInFB();
                            _handleLogin();
                            setState(() {
                              buttonPress = 3;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              buttonPress = 3;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
                            height: 0.104 * c,
                            width: 0.39 * c,
                            decoration: buttonPress == 4
                                ? oauthOnTapDecoration
                                : buttonPress == 3
                                    ? oauthDecoration
                                    : oauthDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 0.078 * c,
                                  child: Image.asset(
                                    "assets/images/facebook.png",
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 0.013 * c),
                                  child: Text(
                                    "Facebook",
                                    style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0468 * c, color: Color.fromRGBO(174, 174, 174, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )

        // Center(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         GestureDetector(
        //           onTap: () => signIn(context),
        //           child: Container(
        //             color: Colors.red,
        //             child: Text("Google"),
        //           ),
        //         ),
        //         Container(
        //           color: Colors.red,
        //           child: Text("facebook"),
        //         )
        //       ],
        //     ),
        //   ),
        );
  }
}





// import 'package:clicksandstories/database/user_database.dart';
// import 'package:clicksandstories/feed-screen/feed_screen.dart';
// import 'package:clicksandstories/google_signin_api.dart';
// import 'package:clicksandstories/models/user.dart' as db;
// import 'package:clicksandstories/tabs_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class LoginScreen extends StatefulWidget {
//   static const routeName = "/login";

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   int counter = 0;
//   int buttonPress = 1;
//   bool isLoading = true;
//   late List<db.User> user;

//   FirebaseAuth _auth = FirebaseAuth.instance;
//   final FacebookLogin _facebookLogin = FacebookLogin();

//   Future _handleLogin() async {
//     FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
//     print(_result.errorMessage);
//     switch (_result.status) {
//       case FacebookLoginStatus.cancelledByUser:
//         print("Login cancelled by user!");
//         break;
//       case FacebookLoginStatus.error:
//         print("Login Error!");
//         break;
//       case FacebookLoginStatus.loggedIn:
//         await _loginWithFacebook(_result);
//         break;
//       default:
//     }
//   }

//   Future _loginWithFacebook(FacebookLoginResult _result) async {
//     FacebookAccessToken _accessToken = _result.accessToken;
//     AuthCredential _credential = FacebookAuthProvider.credential(_accessToken.token);
//     var a = await _auth.signInWithCredential(_credential);
//     print(a);
//     getData(a.user?.displayName, a.user?.email, a.additionalUserInfo?.profile?["picture"]["data"]["url"], a.additionalUserInfo?.profile?["id"], "facebook");
//   }

//   final oauthDecoration = BoxDecoration(
//     color: Colors.white,
//     // color: Color.fromRGBO(239, 238, 238, 1),
//     borderRadius: BorderRadius.all(
//       Radius.circular(40),
//     ),
//     // boxShadow: [
//     //   BoxShadow(
//     //     color: Color.fromRGBO(255, 255, 255, 0.5),
//     //     blurRadius: 6.0,
//     //     offset: Offset(-4, -4),
//     //   ),
//     //   BoxShadow(
//     //     color: Color.fromRGBO(209, 205, 199, 0.5),
//     //     blurRadius: 7.0,
//     //     offset: Offset(3, 3),
//     //   ),
//     // ]);
//   );
//   final oauthOnTapDecoration = BoxDecoration(
//     color: Colors.white,
//     // color: Color.fromRGBO(239, 238, 238, 1),
//     borderRadius: BorderRadius.all(
//       Radius.circular(40),
//     ),
//     // boxShadow: [
//     //   BoxShadow(
//     //     color: Color.fromRGBO(255, 255, 255, 0.5),
//     //     blurRadius: 7.0,
//     //     offset: Offset(3, 3),
//     //   ),
//     //   BoxShadow(
//     //     color: Color.fromRGBO(209, 205, 199, 0.5),
//     //     blurRadius: 6.0,
//     //     offset: Offset(-4, -4),
//     //   ),
//     // ]);
//   );
//   Future getData(String? username, String? email, String? pictureAddress, String? typeId, String type) async {
//     final String url = "http://192.168.128.196:3000/auth/post"; //phone: 192.168.128.196, ethernet:192.168.31.118
//     final response = await http.post(
//       Uri.parse(url),
//       body: {
//         "username": username,
//         "email": email,
//         "photo": pictureAddress,
//         "type": type,
//         "typeId": typeId,
//       },
//     );
//     print(response.body);
//     final user = db.User(name: username, email: email, photo: pictureAddress, type: type);
//     await UserDatabase.instance.create(user);

//     Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
//   }

//   Future signIn(BuildContext context) async {
//     final user = await GoogleSignInApi.login();
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in Failed")));
//     } else {
//       print(user.displayName);
//       print(user.email);
//       print(user.id);
//       print(user.photoUrl);
//       getData(user.displayName!, user.email, user.photoUrl, user.id, "google");
//     }
//   }

//   Future refresh() async {
//     setState(() {
//       isLoading = true;
//     });
//     this.user = await UserDatabase.instance.readAllUsers();
//     if (!this.user.isEmpty && counter == 1) {
//       Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     refresh();
//   }

//   @override
//   Widget build(BuildContext context) {
//     counter++;
//     return Scaffold(
//         backgroundColor: Color.fromRGBO(250, 186, 148, 1),
//         body: isLoading
//             ? Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.purple,
//                 ),
//               )
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 100),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 child: Text(
//                                   "Clicks",
//                                   style: TextStyle(fontFamily: "Conquest", fontSize: 70),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.only(left: 140),
//                                 child: Text(
//                                   "&",
//                                   style: TextStyle(fontFamily: "Conquest", fontSize: 70),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.only(left: 130),
//                                 child: Text(
//                                   "Stories",
//                                   style: TextStyle(fontFamily: "Conquest", fontSize: 70),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(top: 20),
//                         child: Text(
//                           "Explore the world behind the lens",
//                           style: TextStyle(fontFamily: "Montserrat", fontSize: 18, fontWeight: FontWeight.w300),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 70,
//                   ),
//                   Expanded(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.only(topLeft: Radius.circular(180), topRight: Radius.circular(180)),
//                       child: Container(
//                         decoration: BoxDecoration(color: Color.fromRGBO(249, 147, 122, 1)),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.only(top: 50),
//                                   child: Text(
//                                     "Login / Signup",
//                                     style: TextStyle(fontFamily: "Montserrat", fontSize: 18, fontWeight: FontWeight.w300),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(top: 20),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   GestureDetector(
//                                     onTapDown: (_) {
//                                       setState(() {
//                                         buttonPress = 2;
//                                       });
//                                     },
//                                     onTapUp: (_) {
//                                       signIn(context);
//                                       setState(() {
//                                         buttonPress = 1;
//                                       });
//                                     },
//                                     onTapCancel: () {
//                                       setState(() {
//                                         buttonPress = 1;
//                                       });
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.only(left: 10, right: 10),
//                                       height: 40,
//                                       width: 150,
//                                       decoration: buttonPress == 2
//                                           ? oauthOnTapDecoration
//                                           : buttonPress == 1
//                                               ? oauthDecoration
//                                               : oauthDecoration,
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             height: 30,
//                                             child: Image.asset(
//                                               "assets/images/google.png",
//                                             ),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(left: 5),
//                                             child: Text(
//                                               "Google",
//                                               style: TextStyle(fontFamily: "Montserrat", fontSize: 18, color: Color.fromRGBO(174, 174, 174, 1)),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTapDown: (_) {
//                                       setState(() {
//                                         buttonPress = 4;
//                                       });
//                                     },
//                                     onTapUp: (_) async {
//                                       //signIn(context);
//                                       //signInFB();
//                                       _handleLogin();
//                                       setState(() {
//                                         buttonPress = 3;
//                                       });
//                                     },
//                                     onTapCancel: () {
//                                       setState(() {
//                                         buttonPress = 3;
//                                       });
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.only(left: 10, right: 10),
//                                       height: 40,
//                                       width: 150,
//                                       decoration: buttonPress == 4
//                                           ? oauthOnTapDecoration
//                                           : buttonPress == 3
//                                               ? oauthDecoration
//                                               : oauthDecoration,
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             height: 30,
//                                             child: Image.asset(
//                                               "assets/images/facebook.png",
//                                             ),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(left: 5),
//                                             child: Text(
//                                               "Facebook",
//                                               style: TextStyle(fontFamily: "Montserrat", fontSize: 18, color: Color.fromRGBO(174, 174, 174, 1)),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               )

//         // Center(
//         //     child: Row(
//         //       mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //       children: [
//         //         GestureDetector(
//         //           onTap: () => signIn(context),
//         //           child: Container(
//         //             color: Colors.red,
//         //             child: Text("Google"),
//         //           ),
//         //         ),
//         //         Container(
//         //           color: Colors.red,
//         //           child: Text("facebook"),
//         //         )
//         //       ],
//         //     ),
//         //   ),
//         );
//   }
// }
