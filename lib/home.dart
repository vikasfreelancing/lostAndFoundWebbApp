import 'package:flutter/material.dart';
import 'package:lost_and_found_web/constants/logo.dart';
import 'constants/constants.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/login');
        },
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        "ashok.jpg",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          "LOST AND FOUND",
                          style: kAppNameStyle.copyWith(
                            color: Color(0xFFFB9932),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                      child: Center(
                        child: Logo(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text("Angel@CO", style: kCompanyNameStyle),
                        ],
                      ),
                    ),
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
