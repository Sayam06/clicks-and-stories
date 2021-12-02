import 'package:cached_network_image/cached_network_image.dart';
import 'package:clicksandstories/database/user_database.dart';
import 'package:clicksandstories/models/user.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewPostScreen extends StatefulWidget {
  static const routeName = "/view-post";

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  late Map data;
  late List<User> user;
  late bool isLoading;
  bool liked = false;
  int counter = 0;
  late Function refreshData;

  ScrollController _scrollController = ScrollController();

  void scroll(BuildContext context) {
    _scrollController.animateTo(_scrollController.position.minScrollExtent + MediaQuery.of(context).size.height - 20, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  Future likeController() async {
    setState(() {
      isLoading = true;
    });
    final String url;
    if (!liked) {
      url = "https://clicks-and-stories.herokuapp.com/like/" + data["_id"] + "/" + user[0].email.toString();
    } else {
      url = "https://clicks-and-stories.herokuapp.com/dislike/" + data["_id"] + "/" + user[0].email.toString();
    }
    final response = await http.post(Uri.parse(url), headers: {"Accept": "application/json"});
    print(response.body);
    refreshData();
    setState(() {
      isLoading = false;
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
    if (data["likedBy"].contains(user[0].email)) {
      liked = true;
      print(liked);
    } else {
      liked = false;
      print(liked);
    }
    setState(() {
      isLoading = false;
    });
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
    final route = ModalRoute.of(context);

    if (route == null)
      return SizedBox(height: 1);
    else {
      final routeArgs = route.settings.arguments as Map<String, dynamic>;
      data = routeArgs["data"];
      refreshData = routeArgs["refresh"];
      isLoading = false;
    }

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Color.fromRGBO(133, 157, 218, 0.58),
            ))
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      child: CachedNetworkImage(
                        imageUrl: data["photo"],
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          color: Color.fromRGBO(133, 157, 218, 0.58),
                        )),
                        fit: BoxFit.fitHeight,
                      ),
                      // onTap: () => scroll(context),
                      // onVerticalDragStart: (_) => scroll(context),
                      onTapDown: (_) => scroll(context),
                      // onVerticalDragDown: (_) => scroll(context),
                    ),
                  ),
                  SizedBox(height: 0.052 * c),
                  Container(
                    padding: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
                    child: Column(
                      children: [
                        FittedBox(
                          child: Text(
                            data["heading"],
                            style: TextStyle(fontFamily: "Montserrat", fontSize: 0.104 * c),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0.026 * c),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 0.052 * c,
                                        child: Image.asset("assets/images/camera.png"),
                                      ),
                                      Container(
                                        height: 0.052 * c,
                                        // color: Colors.blue,
                                        margin: EdgeInsets.only(top: 0.026 * c, left: 0.026 * c),
                                        child: Text(
                                          data["clickedBy"],
                                          style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0364 * c),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 0.026 * c),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 0.052 * c,
                                          child: Image.asset("assets/images/pen.png"),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 0.026 * c),
                                          child: Text(
                                            data["writtenBy"],
                                            style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0364 * c),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0.026 * c),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 0.039 * c,
                                      child: Image.asset("assets/images/calendar.png"),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 0.026 * c),
                                      child: Text(
                                        data["postDate"],
                                        style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0364 * c),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0.078 * c),
                          child: Text(
                            data["writeup"],
                            style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0468 * c),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0.13 * c),
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 0.078 * c,
                                  child: liked
                                      ? Image.asset(
                                          "assets/images/liked.png",
                                        )
                                      : Image.asset(
                                          "assets/images/like.png",
                                        ),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (liked) {
                                      likeController();
                                      liked = false;
                                    } else {
                                      likeController();
                                      liked = true;
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.13 * c,
                        )
                      ],
                    ),
                  )
                  // Expanded(
                  //   child: DraggableScrollableSheet(
                  //       expand: true,
                  //       builder: (BuildContext context, ScrollController scrollController) {
                  //         return Container(
                  //           child: SingleChildScrollView(
                  //               child: SingleChildScrollView(
                  //             controller: scrollController,
                  //             child: Container(
                  //               child: Text(data["writeup"]),
                  //             ),
                  //           )),
                  //         );
                  //       }),
                  // ),
                ],
              ),
            ),

      //SingleChildScrollView(
      //child:
      // Column(
      //     children: [
      //       Container(
      //         child: Image.network(data["photo"]),
      //       ),
      //       // SizedBox(
      //       //   height: 500,
      //       // ),
      //       Expanded(
      //         child: DraggableScrollableSheet(builder: (BuildContext context, ScrollController scrollController) {
      //           return Container(
      //             child: SingleChildScrollView(
      //               controller: scrollController,
      //               child: Text(data["writeup"]),
      //             ),
      //           );
      //         }),
      //       )
      //     ],
      //   ),
      //),
    );
  }
}
