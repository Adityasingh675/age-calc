import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController _controller;
  double age = 0.0;
  var selectedYear;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    animation = _controller;
    super.initState();
  }

  void _showPicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime(2020),
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        selectedYear = value.year;
        calculateAge();
      });
    });
  }

  void calculateAge() {
    setState(() {
      age = (2020 - selectedYear).toDouble();
      animation = Tween<double>(begin: animation.value, end: age).animate(
          CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));
      animation.addListener(() {
        setState(() {});
      });
    });
    _controller.forward();
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Age Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
              child: Text(selectedYear != null
                  ? selectedYear.toString()
                  : "Select your age of birth"),
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              onPressed: () {
                _showPicker();
              },
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Text(
              "Your age is ${animation.value.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
    );
  }
}
