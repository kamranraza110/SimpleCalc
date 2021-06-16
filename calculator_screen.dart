import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'button.dart';
import 'calc_data.dart';
import 'constants.dart';
import 'history.dart';
import 'static_gridview.dart';

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    myController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white10,
              //constraints: BoxConstraints.expand(),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildText(
                                  calculatedText: 60,
                                  unCalculatedText: 18,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black,
                                  text: Provider.of<CalcData>(context)
                                      .getFormattedResult()),
                              SizedBox(
                                height: 50.0,
                              ),
                              buildText(
                                calculatedText: 18,
                                unCalculatedText: 60,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue,
                                text: Provider.of<CalcData>(context)
                                    .getFormattedExpr(),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.history,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(
                                          child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: History(),
                                      )));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.backspace,
                            ),
                            onPressed: () {
                              Provider.of<CalcData>(context)
                                  .backSpaceExpression();
                              HapticFeedback.vibrate();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.0),
              child: StaticGridView(
                crossAxisCount: 4,
                children: List.generate(kButtonsText.length, (index) {
                  return Expanded(
                    child: CalcButton(
                      text: kButtonsText[index],
                    ),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class buildText extends StatelessWidget {
  final double calculatedText;
  final double unCalculatedText;
  final FontWeight fontWeight;
  final Color color;
  final String text;

  buildText(
      {this.calculatedText,
      this.unCalculatedText,
      this.fontWeight,
      this.color,
      this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: calculatedText > unCalculatedText
          ? calculatedText + 15
          : unCalculatedText + 15,
      child: ListView(
          reverse: true,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: kTextAnimationSpeed),
              style: TextStyle(
                  fontSize: Provider.of<CalcData>(context).isDataCalculated()
                      ? (calculatedText)
                      : (unCalculatedText),
                  fontWeight: fontWeight),
              child: Text(
                text,
                style: TextStyle(color: color),
              ),
            ),
          ]),
    );
  }
}
