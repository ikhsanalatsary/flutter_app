import 'package:flutter/material.dart';

class StackExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.green[200],
            width: 300.0,
            height: 300.0,
          ),
          Container(
            color: Colors.blue[200],
            width: 200.0,
            height: 200.0,
          ),
          Container(
            color: Colors.red[200],
            width: 100.0,
            height: 100.0,
          ),
        ],
      ),
    );
  }
}