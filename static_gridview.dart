import 'package:flutter/cupertino.dart';

class StaticGridView extends StatelessWidget {
  final int crossAxisCount;
  final List<Widget> children;

  StaticGridView({@required this.crossAxisCount, @required this.children});

  @override
  Widget build(BuildContext context) {
    List<Widget> rowList = [];
    int numRows = children.length ~/ crossAxisCount;

    for (var i = 0; i < numRows; i++) {
      rowList.add(Expanded(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                children.sublist(i * crossAxisCount, (i + 1) * crossAxisCount)),
      ));
    }
    return Column(
      children: rowList,
    );
  }
}
