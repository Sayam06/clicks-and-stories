import 'package:clicksandstories/models/writeup.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = "/about-us";

  ScrollController _scrollController = ScrollController();

  void scroll(BuildContext context) {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.13 * c),
          Container(
            margin: EdgeInsets.only(left: 0.052 * c),
            child: Text(
              "About Us",
              style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.065 * c),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: 0.052 * c),
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: about("sayam", "Sayam Sarkar", SAYAM_QUOTE, SAYAM, c),
                    ),
                    onTapDown: (_) => scroll(context),
                  ),
                  SizedBox(height: 0.078 * c),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: about("rishideep", "Rishideep Chatterjee", RISHIDEEP_QUOTE, RISHIDEEP, c),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column about(String pic, String name, String quote, String writeup, var c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 0.0104 * c,
              color: Color.fromRGBO(141, 131, 252, 1),
            ),
          ),
          height: 0.52 * c,
          child: Image.asset(
            "assets/images/$pic.png",
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0.026 * c),
          child: Text(
            name,
            style: TextStyle(fontFamily: "Poppins", fontSize: 0.052 * c),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0.026 * c, left: 0.026 * c, right: 0.026 * c),
          child: Text(
            quote,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 0.0468 * c,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0.026 * c, left: 0.026 * c, right: 0.026 * c),
          child: Text(
            writeup,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 0.0416 * c,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
