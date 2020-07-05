import 'package:flutter/material.dart';
import 'package:lost_and_found_web/constants/constants.dart';
import 'package:lost_and_found_web/screens/foundItem.dart';
import 'package:lost_and_found_web/screens/lostItem.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'dart:io';

import 'package:lost_and_found_web/widget/sideMenu.dart';

class DashBoard extends StatefulWidget {
  final User user;
  final String message;
  final Color color;
  DashBoard({this.user, this.message, this.color});
  @override
  _DashBoard createState() => _DashBoard();
}

class _DashBoard extends State<DashBoard> {
  User user;
  String message;
  Color color;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    message = widget.message;
    color = widget.color;
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    final lostSomething = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LostItem(user: user, pics: List<File>()),
            ),
          );
        },
        child: Text("Lost Something",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 25.0)),
      ),
    );
    final foundSomething = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoundItem(user: user),
            ),
          );
        },
        child: Text("Found Something",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
    );
    return Scaffold(
      drawer: NavDrawer(
        user: user,
      ),
      appBar: AppBar(
        title: Text("Welcome " + user.name, style: kAppNameStyle),
      ),
      body: Center(
        child: Container(
          color: Color(0xFF6D60FB),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'logo2.png',
                  ),
                ),
                SizedBox(
                  height: 100.0,
                  child: Center(
                    child: Text(
                      message == null ? "" : message,
                      style: TextStyle(color: color, fontSize: 20),
                    ),
                  ),
                ),
                lostSomething,
                SizedBox(height: 100.0),
                foundSomething,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
