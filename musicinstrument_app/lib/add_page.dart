import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final dynamic instrument;
  AddPage({this.instrument});
  
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Edit Instrument')),
      body: Center(child: Text('Form Here')),
    );
  }
}
