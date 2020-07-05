import 'package:flutter/material.dart';
import 'constants.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF7367FB),
      ),
      child: Container(
        width: double.infinity,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF8D84FB),
        ),
        child: Center(
            child: Text(
          "V2",
          style: kLogoTextStyle,
        )),
      ),
    );
  }
}
