import 'package:clicksandstories/about-app-privacy-screen/about_app_privacy_screen.dart';
import 'package:clicksandstories/about-us-screen/about_us_screen.dart';
import 'package:clicksandstories/database/user_database.dart';
import 'package:clicksandstories/google_signin_api.dart';
import 'package:clicksandstories/joinus-screen/joinus_screen.dart';
import 'package:clicksandstories/models/about_app.dart';
import 'package:clicksandstories/models/privacy.dart';
import 'package:clicksandstories/models/user.dart' as db;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin<ProfileScreen> {
  late List<db.User> user;
  late String picture;
  bool isLoading = true;
  int counter = 0;

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

  Future userSignOut(db.User user, BuildContext context) async {
    if (user.type == "google") {
      await GoogleSignInApi.logout();
    } else {
      await FirebaseAuth.instance.signOut();
      FacebookLogin().logOut();
      print("loggedOut of fb");
    }
    await UserDatabase.instance.delete(user.id!);

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    super.build(context);
    counter++;
    return Scaffold(
        backgroundColor: Colors.white, //Color.fromRGBO(133, 157, 218, 0.58), //
        body: isLoading
            ? CircularProgressIndicator(
                color: Color.fromRGBO(133, 157, 218, 0.58),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.13 * c),
                  Container(
                    margin: EdgeInsets.only(left: 0.052 * c),
                    child: Text(
                      "Profile",
                      style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.065 * c),
                    ),
                  ),
                  SizedBox(height: 0.078 * c),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 0.39 * c,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(360),
                          child: picture == "assets/images/cat.jpeg" ? Image.asset(picture, fit: BoxFit.fill) : Image.network(picture, fit: BoxFit.fill),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0.052 * c),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            user[0].name.toString().split(" ")[0],
                            style: TextStyle(fontFamily: "Montserrat", fontSize: 0.078 * c),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0.052 * c, top: 0.13 * c),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Container(
                            child: Text(
                              "About Us",
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0702 * c),
                            ),
                          ),
                          onTap: () => Navigator.of(context).pushNamed(AboutUsScreen.routeName),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 0.026 * c),
                            child: Text(
                              "About App",
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0702 * c),
                            ),
                          ),
                          onTap: () => Navigator.of(context).pushNamed(AboutAppPrivacy.routeName, arguments: {
                            "heading": "About App",
                            "text": ABOUTAPP,
                          }),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 0.026 * c),
                            child: Text(
                              "Join Our Team!",
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0702 * c),
                            ),
                          ),
                          onTap: () => {Navigator.of(context).pushNamed(JoinUs.routeName)},
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 0.026 * c),
                            child: Text(
                              "Privacy",
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0702 * c),
                            ),
                          ),
                          onTap: () => Navigator.of(context).pushNamed(AboutAppPrivacy.routeName, arguments: {
                            "heading": "Privacy",
                            "text": PRIVACY,
                          }),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 0.026 * c),
                            child: Text(
                              "Log Out",
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0702 * c, color: Colors.red),
                            ),
                          ),
                          onTap: () => userSignOut(user[0], context),
                        ),
                      ],
                    ),
                  )
                ],
              ));
  }
}
