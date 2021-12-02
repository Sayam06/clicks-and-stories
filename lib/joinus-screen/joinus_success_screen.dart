import 'dart:async';

import 'package:clicksandstories/feed-screen/feed_screen.dart';
import 'package:clicksandstories/tabs_screen.dart';
import 'package:flutter/material.dart';

class JoinusSuccessScreen extends StatefulWidget {
  static const routeName = "/success-joinus";

  @override
  _JoinusSuccessScreenState createState() => _JoinusSuccessScreenState();
}

class _JoinusSuccessScreenState extends State<JoinusSuccessScreen> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    counter++;
    if (counter == 1) {
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
      });
    }
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Container(
            margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
            child: Text(
              "Your request has been submitted successfully!",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 0.065 * c,
                color: Color.fromRGBO(141, 131, 252, 1),
              ),
            ),
          )),
        ));
  }
}
