import 'package:clicksandstories/about-app-privacy-screen/about_app_privacy_screen.dart';
import 'package:clicksandstories/about-us-screen/about_us_screen.dart';
import 'package:clicksandstories/error-screen/error_screen.dart';
import 'package:clicksandstories/feed-screen/feed_screen.dart';
import 'package:clicksandstories/joinus-screen/joinus_screen.dart';
import 'package:clicksandstories/joinus-screen/joinus_success_screen.dart';
import 'package:clicksandstories/login-screen/login_screen.dart';
import 'package:clicksandstories/tabs_screen.dart';
import 'package:clicksandstories/view-post/view_post_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clicks and Stories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        TabsScreen.routeName: (ctx) => TabsScreen(),
        FeedScreen.routeName: (ctx) => FeedScreen(),
        ViewPostScreen.routeName: (ctx) => ViewPostScreen(),
        JoinUs.routeName: (ctx) => JoinUs(),
        JoinusSuccessScreen.routeName: (ctx) => JoinusSuccessScreen(),
        AboutAppPrivacy.routeName: (ctx) => AboutAppPrivacy(),
        AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
        ErrorScreen.routeName: (ctx) => ErrorScreen(),
      },
    );
  }
}

//0.0026
