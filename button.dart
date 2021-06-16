import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'calc_data.dart';

class CalcButton extends StatelessWidget {
  final String text;

  CalcButton({this.text});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.blueAccent,
      focusColor: Colors.blueAccent,
      autofocus: true,
      hoverColor: Colors.blueAccent,
      child: Text(
        this.text,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      //splashColor: Colors.blueAccent,
      onPressed: () {
        Provider.of<CalcData>(context).updateExpression(text);
        HapticFeedback.vibrate();
      },
    );
  }
}
