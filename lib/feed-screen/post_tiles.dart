import 'package:cached_network_image/cached_network_image.dart';
import 'package:clicksandstories/view-post/view_post_screen.dart';
import 'package:flutter/material.dart';

class PostTiles extends StatelessWidget {
  Map data;
  Function refresh;

  PostTiles(this.data, this.refresh);

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.only(left: 0.013 * c, right: 0.013 * c, bottom: 0.052 * c),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl: data["photo"],
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Color.fromRGBO(133, 157, 218, 0.58))),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.37), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 0.013 * c, top: 0.026 * c, left: 0.026 * c, right: 0.026 * c),
                          child: Text(
                            data["heading"],
                            style: TextStyle(fontFamily: "Montserrat", color: Colors.white, fontSize: 0.065 * c),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 0.026 * c, top: 0.013 * c, left: 0.026 * c, right: 0.026 * c),
                          child: Text(
                            data["writeup"].toString().substring(0, 100) + "....",
                            style: TextStyle(fontFamily: "Montserrat", color: Colors.white, fontSize: 0.0364 * c),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(133, 157, 218, 0.58), //Color.fromRGBO(133, 157, 218, 0.58), Color.fromRGBO(224, 250, 81, 0.58)
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                ),
                padding: EdgeInsets.only(top: 0.026 * c, bottom: 0.026 * c),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0.104 * c),
                      child: Row(
                        children: [
                          Container(
                              child: Image.asset(
                            "assets/images/like.png",
                            height: 0.052 * c,
                          )),
                          Container(
                            margin: EdgeInsets.only(left: 0.013 * c),
                            child: Text(
                              data["likes"].toString(),
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 0.039 * c),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 0.104 * c),
                      child: Row(
                        children: [
                          Container(
                              child: Image.asset(
                            "assets/images/calendar.png",
                            height: 0.052 * c,
                          )),
                          Container(
                            margin: EdgeInsets.only(left: 0.013 * c),
                            child: Text(
                              data["postDate"],
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 0.039 * c),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
      onTap: () => Navigator.of(context).pushNamed(ViewPostScreen.routeName, arguments: {
        "data": data,
        "refresh": refresh,
      }),
    );
  }
}
