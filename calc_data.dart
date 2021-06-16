import 'package:flutter/foundation.dart';
import 'package:stack/stack.dart';

import 'constants.dart';
import 'engine.dart';

class CalcData extends ChangeNotifier {
  String _expression = '';
  String _result = '';
  Stack<String> operators = Stack();
  Engine engine = Engine();
  bool _isDataCalculated = false;
  List<String> history = [];

  String numberFormatter(String num) {
    String ret = '';
    String left = num.split('.').first;
    String right = num.contains('.') ? num.split('.').last : '';
    int j = left.length;
    while (j > 3) {
      j -= 3;
      left = left.substring(0, j) + ',' + left.substring(j);
    }

    return num.contains('.') ? left + '.' + right : left;
  }

  String getFormattedExpr() {
    String ret = "";

    if (_expression != '') {
      int j = 0;
      int lastOp = -1;
      int numCommas = 0;
      for (int i = 0; i < _expression.length; i++) {
        // If we are at an operator, it means the string before it was a number
        if (isOperator(_expression[i])) {
          lastOp = i;
          ret = ret + _expression[i];
          numCommas = ret.split(',').length - 1;
        } else {
          ret = ret.substring(0, lastOp + 1 + numCommas) +
              numberFormatter(_expression.substring(lastOp + 1, i + 1));
        }
      }
    }
    return ret;
  }

  String getFormattedResult() {
    return _result != ''
        ? numberFormatter(this.getResult())
        : getFormattedExpr();
  }

  String getExpression() {
    return _expression;
  }

  String getResult() {
    return _result;
  }

  bool isDataCalculated() {
    return _isDataCalculated;
  }

  void backSpaceExpression() {
    if (this.getExpression() != "") {
      String expr = _expression;
      if (_expression[_expression.length - 1] == '(' && operators.isNotEmpty) {
        operators.pop();
      }
      _expression = expr.substring(0, expr.length - 1);

      notifyListeners();
      updateResult();
    }
  }

  bool isOperator(String str) {
    return kOperators.containsKey(str);
  }

  bool updateExpression(String str) {
    if ((str == '( )' || (str != 'C' && str != '=')) &&
        _expression.length > 50) {
      return false;
    } else {
      switch (str) {
        case '( )':
          {
            if (operators.isEmpty ||
                kOperators.containsKey(
                    _expression.substring(_expression.length - 1))) {
              if (!kOperators
                  .containsKey(_expression.substring(_expression.length - 1))) {
                _expression = _expression + 'x';
              }
              _expression = _expression + '(';
              operators.push('(');
            } else {
              _expression = _expression + ')';
              operators.pop();
            }
          }
          break;
        case 'C':
          {
            while (operators.isNotEmpty) {
              operators.pop();
            }
            _expression = '';
            _result = '';
            _isDataCalculated = false;
            engine.reset();
          }
          break;
        case '=':
          {
            _isDataCalculated = true;
            engine.reset();
            notifyListeners();
            history.add(this.getFormattedExpr());
          }
          break;
        default:
          {
            if (_isDataCalculated) {
              _isDataCalculated = false;
              if (kOperators.containsKey(str)) {
                _expression = _result;
              } else {
                _expression = '';
              }
            }
            if (_expression != '' &&
                kOperators.containsKey(_expression[_expression.length - 1]) &&
                kOperators.containsKey(str)) {
              _expression =
                  _expression.replaceRange(_expression.length - 1, null, str);
            } else {
              _expression += str;
            }
          }
      }
    }
    notifyListeners();
    updateResult();
    return true;
  }

  void updateResult() {
    var temp = '';
    if (this._expression != '') {
      temp = engine.calculate(_expression).toString();
      if (temp.endsWith('.0')) {
        temp = temp.replaceFirst('.0', '');
      } else if (temp.length > 10) {
        temp = double.parse(temp).toStringAsFixed(10);
      }
      this._result = temp != "null" ? temp : this._result = this._result;
    } else {
      this._result = '';
    }
    notifyListeners();
  }
}
