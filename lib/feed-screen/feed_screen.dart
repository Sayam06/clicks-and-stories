import 'package:clicksandstories/error-screen/error_screen.dart';
import 'package:clicksandstories/feed-screen/post_tiles.dart';
import 'package:clicksandstories/profile-screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedScreen extends StatefulWidget {
  static const routeName = "/feed";

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with AutomaticKeepAliveClientMixin<FeedScreen> {
  bool isLoading = true;
  List data = [];
  List version = [];

  @override
  bool get wantKeepAlive => true;

  Future getVersion() async {
    setState(() {
      isLoading = true;
    });
    final String url = "https://clicks-and-stories.herokuapp.com/version"; //phone 192.168.128.196 ethernet:192.168.31.118
    final response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    version = json.decode(response.body);
    if (version[0]["version"] == "1.0.0") {
      getData();
    } else {
      Navigator.pushReplacementNamed(context, ErrorScreen.routeName);
    }
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    final String url = "https://clicks-and-stories.herokuapp.com/posts"; //phone 192.168.128.196 ethernet:192.168.31.118
    final response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    data = json.decode(response.body);
    setState(() {
      isLoading = false;
    });
  }

  void refresh() {
    getData();
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.13 * c),
          Container(
            margin: EdgeInsets.only(left: 0.052 * c, right: 0.052 * c),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Feed",
                  style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.065 * c),
                ),
                GestureDetector(
                  child: Icon(Icons.refresh),
                  onTap: () => getData(),
                )
              ],
            ),
          ),
          // SizedBox(height: ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Color.fromRGBO(133, 157, 218, 0.58),
                ))
              : Expanded(
                  child: ListView.builder(
                  padding: EdgeInsets.only(top: 0.052 * c, bottom: 0.13 * c),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return PostTiles(data[index], getData);
                  },
                  itemCount: data.length,
                ))
        ],
      ),
    );
  }
}
