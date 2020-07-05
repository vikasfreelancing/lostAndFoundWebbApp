import 'package:flutter/material.dart';
import 'package:lost_and_found_web/constants/constants.dart';
import 'package:lost_and_found_web/constants/message_constants.dart';
import 'package:lost_and_found_web/model/LostItem.dart';
import 'package:lost_and_found_web/screens/loading.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/screens/lostItemViewList.dart';
import 'package:lost_and_found_web/services/itemService.dart';
import 'package:lost_and_found_web/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_web/notifications/registerNotification.dart';

class LogIn extends StatefulWidget {
  LogIn({this.message, this.color});
  final String message;
  final Color color;
  @override
  _LogInState createState() => _LogInState(message: message, color: color);
}

class _LogInState extends State<LogIn> with WidgetsBindingObserver {
  var messageConstants = MessageConstants();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  final _auth = FirebaseAuth.instance;
  String email, password;
  Color color = Colors.green;
  _LogInState({this.message, this.color});
  String message;
  void login() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
              message: messageConstants.CHECKING_CREDENTIALS,
              task: () async {
                User user = await UserService().loginUser(email, password);
                if (user != null) {
                  print("Logged in user Id " + user.id);
                  //await Notifications(email: user.email).registerNotification();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                        message: "Loading Data ",
                        task: () async {
                          List<LostItem> items =
                              await ItemService().getLostItems(user.id);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LostItemView(
                                        items: items,
                                        user: user,
                                      )));
                        },
                      ),
                    ),
                  );
                } else {
                  print('invalid user name or password');
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogIn(
                        message: messageConstants.PERMISSION_DENIED,
                        color: Colors.red[900],
                      ),
                    ),
                  );
                }
              }),
        ));
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      onChanged: (text) {
        email = text;
      },
      textAlign: TextAlign.center,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      onChanged: (text) {
        password = text;
      },
      textAlign: TextAlign.center,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          login();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Color(0xff685EF2), fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Lets find together", style: kAppNameStyle),
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
                  height: 45.0,
                  child: Center(
                    child: Text(
                      message == null ? "" : message,
                      style: TextStyle(color: color, fontSize: 20),
                    ),
                  ),
                ),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Dont have account?",
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/registor");
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
