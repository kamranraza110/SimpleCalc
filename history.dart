import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calc_data.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: List.generate(Provider.of<CalcData>(context).history.length,
            (index) {
          return ListTile(
            title: Text(Provider.of<CalcData>(context).history[index]),
          );
        }),
      ),
    );
  }
}
