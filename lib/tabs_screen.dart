import 'package:clicksandstories/database/user_database.dart';
import 'package:clicksandstories/feed-screen/feed_screen.dart';
import 'package:clicksandstories/models/user.dart';
import 'package:clicksandstories/profile-screen/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "/tabs";

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> pages = [FeedScreen(), ProfileScreen()];
  late List<User> user;
  late String picture;
  bool isLoading = true;
  int counter = 0;

  int selectedPageIndex = 0;
  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
      pageController.jumpToPage(selectedPageIndex);
    });
  }

  late PageController pageController = PageController(initialPage: selectedPageIndex);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
    if (this.user.isEmpty && counter == 1) {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
    picture = user[0].photo ?? "assets/images/cat.jpeg";
    print(picture);
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
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            body: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: pages,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              height: 0.13 * c,
              color: Color.fromRGBO(133, 157, 218, 1), //Color.fromRGBO(167, 202, 24, 1), //Color.fromRGBO(133, 157, 218, 1), //Color.fromRGBO(224, 250, 81, 1)
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Colors.white, //Color.fromRGBO(111, 115, 222, 1),

              items: <Widget>[
                Container(
                    child: Image.asset(
                  "assets/images/feed.png",
                  height: 0.078 * c,
                  color: Colors.black,
                )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: Container(
                      child: isLoading
                          ? SizedBox()
                          : Image.network(
                              picture,
                              height: 0.091 * c,
                            )),
                ),
              ],
              onTap: (index) {
                selectedPageIndex = index;
                selectPage(selectedPageIndex);
              },
            )

            //  BottomNavigationBar(
            //   onTap: selectPage,
            //   unselectedItemColor: Colors.black,
            //   selectedItemColor: Colors.white, //Color.fromRGBO(41, 120, 181, 1),
            //   currentIndex: selectedPageIndex,
            //   showSelectedLabels: false,
            //   showUnselectedLabels: false,
            //   backgroundColor: Colors.white,
            //   items: [
            //     BottomNavigationBarItem(
            //         icon: Container(
            //           margin: EdgeInsets.only(bottom: 10),
            //           child: Image.asset(
            //             "assets/images/feed.png",
            //             height: 30,
            //             color: selectedPageIndex == 0 ? Color.fromRGBO(111, 115, 222, 1) : Colors.black,
            //           ),
            //         ),
            //         title: Text(
            //           "Feed",
            //           style: TextStyle(fontSize: 0),
            //         )),
            //     BottomNavigationBarItem(
            //         title: Text(
            //           "Feed",
            //           style: TextStyle(fontSize: 0),
            //         ),
            //         icon: Container(
            //           margin: EdgeInsets.only(bottom: 10),
            //           child: Image.asset(
            //             "assets/images/profile.png",
            //             height: 30,
            //             color: selectedPageIndex == 1 ? Color.fromRGBO(111, 115, 222, 1) : Colors.black,
            //           ),
            //         ))
            //   ],
            // )

            // Container(
            //   height: 70,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(30.0),
            //       topRight: Radius.circular(30.0),
            //     ),
            // child: BottomNavigationBar(
            //   onTap: selectPage,
            //   unselectedItemColor: Colors.black,
            //   selectedItemColor: Colors.white, //Color.fromRGBO(41, 120, 181, 1),
            //   currentIndex: selectedPageIndex,
            //   showSelectedLabels: false,
            //   showUnselectedLabels: false,
            //   backgroundColor: Colors.white,
            //   items: [
            //     BottomNavigationBarItem(
            //         icon: Container(
            //           child: Image.asset(
            //             "assets/images/feed.png",
            //             height: 40,
            //             color: selectedPageIndex == 0 ? Color.fromRGBO(111, 115, 222, 1) : Colors.black,
            //           ),
            //         ),
            //         title: Text("Feed")),
            //     BottomNavigationBarItem(
            //         icon: Container(
            //           child: Image.asset(
            //             "assets/images/profile.png",
            //             height: 40,
            //             color: selectedPageIndex == 1 ? Color.fromRGBO(111, 115, 222, 1) : Colors.black,
            //           ),
            //         ),
            //             title: Text("Profile"))
            // BottomNavigationBarItem(
            //   icon: Container(
            //       child: selectedPageIndex == 0
            //           ? Container(
            //               height: 50,
            //               child: Image.asset(
            //                 "assets/images/feedSelected.png",
            //               ),
            //             )
            //           : Container(
            //               height: 30,
            //               child: Image.asset(
            //                 "assets/images/feed.png",
            //               ),
            //             )),
            //   //Icon(Icons.category_outlined),
            //   title: Text(
            //     "Feed",
            //     style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
            //   ),
            // ),
            // BottomNavigationBarItem(
            //   icon: Container(
            //       child: selectedPageIndex == 1
            //           ? Container(
            //               height: 40,
            //               child: Image.asset(
            //                 "assets/images/profileSelected.png",
            //               ),
            //             )
            //           : Container(
            //               height: 30,
            //               child: Image.asset(
            //                 "assets/images/profile.png",
            //               ),
            //             )),
            //   title: Text(
            //     "Profile",
            //     style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
            //   ),
            // ),
            //],
            //),
            //     ),
            //   ),
            // ),
            ));
  }
}
