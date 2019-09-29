import 'package:flutter/material.dart';

class ContainerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            color: Colors.yellow,
          ),
          Container(
            width: 100.0,
            height: 100.0,
            color: Colors.blue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                color: Colors.blueGrey,
              ),
              Container(
                width: 100.0,
                height: 100.0,
                color: Colors.blue,
              ),
            ],
          )
        ],
      ),
    );
  }
}
