import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calc_data.dart';
import 'calculator_screen.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => CalcData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: SimpleCalculator(),
      ),
    );
  }
}
