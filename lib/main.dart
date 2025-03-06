import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(DevicePreview(builder: (context) => MyApp(), enabled: true));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'icon.png',
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.width * 0.06,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Ad Loading..',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.width * 0.07,
                    child: const CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 2, // Makes it thinner
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _expression = "0";
  String _equation = "";
  String _result = "0";

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "AC") {
        _expression = "0";
        _result = "0";
        _equation = "";
      } else if (value == "C") {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        if (_expression == '') {
          _expression = "0";
          _equation = "";
        }
      } else if (value == "=") {
        try {
          _equation = _expression;
          _result = _calculateResult(_expression);
          _expression = _result;
        } catch (e) {
          _result = "Error";
        }
      } else {
        if (_expression == '0') {
          _expression = value;
          _equation = "";
        } else {
          _equation = "";
          _expression += value;
        }
      }
    });
  }

  String _calculateResult(String expression) {
    try {
      expression = expression.replaceAll("X", "*");
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            "Calculator",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      textAlign: TextAlign.right,
                      _equation,
                      style: TextStyle(fontSize: 30, color: Colors.black54),
                    ),
                    Text(
                      textAlign: TextAlign.right,
                      _expression,
                      style: TextStyle(
                        fontSize: 65,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          CalButton(["AC", "C", "%", "/"], Colors.black38),
          CalButton(["7", "8", "9", "X"], Colors.black38),
          CalButton(["4", "5", "6", "-"], Colors.black38),
          CalButton(["1", "2", "3", "+"], Colors.black38),
          CalButton(["00", "0", ".", "="], Colors.black38),
        ],
      ),
    );
  }

  Widget CalButton(List<String> labels, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) => _buildButton(label, color)).toList(),
    );
  }

  Widget _buildButton(String label, Color color) {
    return GestureDetector(
      onTap: () => _onButtonPressed(label),
      child: Container(
        height: 65,
        width: 65,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _btn_color(label),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _btn_color(String label) {
    if (label == "AC" ||
        label == "C" ||
        label == "=" ||
        label == "+" ||
        label == "-" ||
        label == "X" ||
        label == "%" ||
        label == "/") {
      return Colors.orange; // Orange for operators
    } else {
      return Colors.black38;
    }
  }
}
