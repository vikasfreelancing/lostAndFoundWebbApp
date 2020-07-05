import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({this.task, this.message});
  final Function task;
  final String message;
  @override
  _LoadingScreenState createState() => _LoadingScreenState(task: task);
}

class _LoadingScreenState extends State<LoadingScreen> {
  _LoadingScreenState({this.task});
  Function task;
  String message = "Please wait.. ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(task);
    if (task != null) {
      task();
    }
    message += widget.message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'logo2.png',
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SpinKitWave(
                size: 150,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
