import 'package:flutter/material.dart';
import 'package:lost_and_found_web/constants/constants.dart';
import 'package:lost_and_found_web/services/userService.dart';
import 'package:lost_and_found_web/dto/User.dart';
import 'package:lost_and_found_web/screens/loading.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  void registerUser(User user) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            message: "Saving Details :",
            task: () async {
              UserService userService = UserService();
              User isRegistered = await userService.registerUser(user);
              Color color;
              if (isRegistered == null ||
                  isRegistered.message == "Registered sucessfully")
                color = Colors.red[900];
              else
                color = Colors.green[900];

              print("isRegistered : " + isRegistered.toString());
              if (isRegistered != null) {
                final authReg = await _auth.createUserWithEmailAndPassword(
                    email: isRegistered.email, password: isRegistered.password);
                Firestore.instance
                    .collection("users")
                    .add({"email": isRegistered.email});
                if (authReg == null) {
                  Navigator.pushNamed(context, "/");
                }
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogIn(
                      message: isRegistered.message,
                      color: color,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogIn(
                      message: "Can not Register something went wrong",
                      color: color,
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  User user = User();
  @override
  Widget build(BuildContext context) {
    final name = TextFormField(
      onChanged: (text) {
        user.name = text;
      },
      validator: (name) {
        Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(name))
          return 'Invalid username';
        else
          return null;
      },
      obscureText: false,
      textAlign: TextAlign.center,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final email = TextFormField(
      validator: (email) =>
          EmailValidator.validate(email) ? null : "Invalid email address",
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      onChanged: (text) {
        user.email = text;
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final phone = TextFormField(
      keyboardType: TextInputType.phone,
      textAlign: TextAlign.center,
      onChanged: (text) {
        user.phone = text;
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final aadhar = TextFormField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onChanged: (text) {
        user.aadhar = text;
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "aadhar",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      onChanged: (text) {
        user.password = text;
      },
      validator: (password) {
        Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(password))
          return 'Invalid password';
        else if (password.length < 6)
          return 'Min password length is 6';
        else
          return null;
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
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          //print(user.phone);
          //print(user.password);
          if (_formKey.currentState.validate()) {
            registerUser(user);
          }
        },
        child: Text("Register",
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
            child: Form(
              key: _formKey,
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
                  SizedBox(height: 45.0),
                  name,
                  SizedBox(height: 25.0),
                  email,
                  SizedBox(
                    height: 15.0,
                  ),
                  phone,
                  SizedBox(
                    height: 15.0,
                  ),
                  aadhar,
                  SizedBox(
                    height: 15.0,
                  ),
                  passwordField,
                  SizedBox(
                    height: 15.0,
                  ),
                  registerButton,
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have account?",
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          "LogIn",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
