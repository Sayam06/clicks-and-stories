import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static const routeName = "/error-screen";

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
        child: Text(
          "Internal server error. Please try again later :(",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 0.065 * c,
            color: Color.fromRGBO(141, 131, 252, 1),
          ),
        ),
      )),
    );
  }
}
