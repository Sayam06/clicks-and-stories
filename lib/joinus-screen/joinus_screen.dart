import 'package:clicksandstories/database/user_database.dart';
import 'package:clicksandstories/joinus-screen/joinus_success_screen.dart';
import 'package:clicksandstories/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinUs extends StatefulWidget {
  static const routeName = "/join-us";

  @override
  _JoinUsState createState() => _JoinUsState();
}

class _JoinUsState extends State<JoinUs> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = true;
  late List<User> user;
  int counter = 0;
  String type = "Writer";
  String errorText = "";
  var typeData = ["Writer", "Photographer", "Other"];

  Future sendData() async {
    setState(() {
      isLoading = true;
    });
    if (phoneController.text.length >= 14 || (phoneController.text.length < 10 && phoneController.text != "")) {
      errorText = "Please enter a valid phone number!";
      setState(() {
        isLoading = false;
      });
      return;
    }
    final String url = "https://clicks-and-stories.herokuapp.com/joinus";
    final response = await http.post(Uri.parse(url), body: {
      "name": nameController.text,
      "email": emailController.text,
      "phoneNumber": phoneController.text,
      "domain": type,
    });
    print(response);
    Navigator.of(context).pushNamed(JoinusSuccessScreen.routeName);
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
    if (this.user.isEmpty && counter == 1) {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
    nameController.text = user[0].name.toString();
    emailController.text = user[0].email.toString();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    counter++;
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.13 * c),
            Container(
              margin: EdgeInsets.only(left: 0.052 * c),
              child: Text(
                "Join Us!",
                style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.065 * c),
              ),
            ),
            SizedBox(height: 0.13 * c),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Color.fromRGBO(133, 157, 218, 0.58),
                  ))
                : Container(
                    margin: EdgeInsets.only(left: 0.052 * c, right: 0.052 * c),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c),
                          child: Text(
                            "Name",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.0468 * c),
                          ),
                        ),
                        Container(
                          height: 0.15 * c,
                          padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                          margin: EdgeInsets.only(bottom: 0.054 * c),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                            border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                          ),
                          child: TextField(
                            enabled: false,
                            scrollPhysics: BouncingScrollPhysics(),
                            maxLines: null,
                            controller: nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "What is your name?",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c),
                          child: Text(
                            "Email",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.0468 * c),
                          ),
                        ),
                        Container(
                          height: 0.15 * c,
                          padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                          margin: EdgeInsets.only(bottom: 0.054 * c),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                            border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                          ),
                          child: TextField(
                            enabled: false,
                            scrollPhysics: BouncingScrollPhysics(),
                            maxLines: null,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "What is your name?",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c),
                          child: Text(
                            "Phone",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.0468 * c),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c, bottom: 0.013 * c),
                          child: Text(
                            "We will only text you if you don't respond to our emails. Chillax, it's not compulsory.",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 0.026 * c),
                          ),
                        ),
                        Container(
                          height: 0.15 * c,
                          padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                          margin: EdgeInsets.only(bottom: 0.054 * c),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                            border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            scrollPhysics: BouncingScrollPhysics(),
                            maxLines: null,
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Only texts, no calls :)",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c),
                          child: Text(
                            "Domain",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 0.0468 * c),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c),
                          width: 0.39 * c,
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(hintText: "Enter the type of file", border: InputBorder.none),
                                isEmpty: type == "",
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    elevation: 1,
                                    value: type,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      setState(() {
                                        type = newValue.toString();
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: typeData.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Color.fromRGBO(141, 131, 252, 1), fontFamily: "Poppins"),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c, bottom: 0.013 * c, top: 0.026 * c),
                          child: Text(
                            "The other necessary information and details will be mailed to you.",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 0.026 * c),
                          ),
                        ),
                        SizedBox(height: 0.052 * c),
                        GestureDetector(
                          child: Center(
                            child: Container(
                              width: 0.39 * c,
                              height: 0.117 * c,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(141, 131, 252, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Apply Now!",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 0.0468 * c,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () => {sendData()},
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.026 * c, top: 0.013 * c),
                          child: Text(
                            errorText,
                            style: TextStyle(fontFamily: "Poppins", color: Colors.red, fontSize: 0.026 * c),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
