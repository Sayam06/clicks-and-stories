import 'package:flutter/material.dart';

class AboutAppPrivacy extends StatelessWidget {
  static const routeName = "/about-us-privacy";
  int counter = 0;
  late String heading;
  late String text;

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    final route = ModalRoute.of(context);

    if (route == null)
      return SizedBox(height: 1);
    else {
      final routeArgs = route.settings.arguments as Map<String, dynamic>;
      heading = routeArgs["heading"];
      text = routeArgs["text"];
      // isLoading = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.13 * c),
          Container(
            margin: EdgeInsets.only(left: 0.052 * c),
            child: Text(
              heading,
              style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.065 * c),
            ),
          ),
          SizedBox(height: 0.13 * c),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 0.052 * c, right: 0.052 * c),
                child: Text(
                  text,
                  style: TextStyle(fontFamily: "Montserrat", color: Colors.black, fontSize: 0.0468 * c),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
