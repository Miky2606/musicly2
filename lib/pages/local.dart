import 'package:flutter/material.dart';

class local extends StatefulWidget {
  local({Key key}) : super(key: key);

  @override
  _localState createState() => _localState();
}

class _localState extends State<local> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("local")),
    );
  }
}
