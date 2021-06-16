import 'dart:collection';

import 'package:stack/stack.dart';

import 'constants.dart';

class Engine {
  //final String expr;
  Stack<String> operators = Stack();

  List output = [];

  void reset() {
    output.clear();
    while (operators.isNotEmpty) {
      operators.pop();
    }
  }

  double calculate(String expr) {
    try {
      ListQueue<double> calcNums = ListQueue();

      parse(expr);
      print(output);

      for (int i = 0; i < output.length; i++) {
        if (!kOperators.containsKey(output[i])) {
          calcNums.add(double.parse(output[i]));
        } else {
          double op1;
          double op2;
          String operand = output[i];

          if (calcNums.isNotEmpty) op1 = calcNums.removeLast();
          if (calcNums.isNotEmpty) op2 = calcNums.removeLast();
          if (op1 != null && op2 != null) {
            double res = evaluate(op2, op1, operand);
            calcNums.addLast(res);
          }
        }
      }
      return calcNums.first;
    } catch (e) {
      print(e);
    }
  }

  List parse(String expr) {
    output.clear();
    String tempStr = '';

    while (expr.isNotEmpty) {
      // First search for the first number in expr
      if (!kOperators.containsKey(expr[0])) {
        tempStr += expr[0];

        print("expression before: " + expr);
      } else {
        // At this point we should be at an operator
        // Add the number to the output list
        if (tempStr != '') {
          output.add(tempStr);
          tempStr = '';
        } else if (output.isEmpty && (expr[0] == '+' || expr[0] == '-')) {
          output.add(
              '0'); //If the first operator is a '+' or '-', we can safely assume a 0 before it
        }

        // 1. Add the operator to the operators stack only if the precedence of it
        // exceeds the precedence of the top of the operators stack
        // 2. If it's a '(', just add it to the stack
        // 3. If it's a ')', pop all the operators until and including '('
        if (expr[0] == '(')
          operators.push(expr[0]);
        else if (expr[0] == ')' && operators.isNotEmpty) {
          while (operators.top() != '(') {
            output.add(operators.pop());
          }
          operators.pop();
        } else if (operators.isEmpty)
          operators.push(expr[0]);
        else if ((kOperators.containsKey(expr[0]) &&
            kOperators[operators.top()] < kOperators[expr[0]])) {
          operators.push(expr[0]);
        }

        // If the precedence of the operator found is less than or equal to the
        // top of the operator stack, calculate the expression so far
        else {
          while (operators.isNotEmpty &&
              (kOperators[operators.top()] >= kOperators[expr[0]])) {
            output.add(operators.pop());
          }
          operators.push(expr[0]);
        }
      }

      //Remove the first char from the current expr
      expr = expr.substring(1);

      print("expression after: " + expr);
      print(output);
    }

    // The last number in the expression needs to be added to the
    if (tempStr != '') {
      output.add(tempStr);
    }

    // Add all the leftovers operators to the output
    while (operators.isNotEmpty) {
      output.add(operators.pop());
    }

    return output;
  }

  double evaluate(double num1, double num2, String op) {
    double result = 0.0;
    print('Evaluataing...');
    switch (op) {
      case 'x':
        {
          result = num1 * num2;
        }
        break;
      case '+':
        {
          result = num1 + num2;
        }
        break;
      case '-':
        {
          result = num1 - num2;
        }
        break;
      case '\u00F7':
        {
          result = num1 / num2;
        }
        break;
      case '%':
        {
          result = (num1 / 100) * num2;
        }
    }

    return result;
  }
}
