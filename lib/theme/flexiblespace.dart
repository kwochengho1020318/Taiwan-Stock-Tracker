import 'package:flutter/material.dart';

class MyfliexibleSpace extends StatelessWidget{
  Widget build(context){
    return Container(
    decoration:  BoxDecoration(
      gradient: LinearGradient(
        colors: [Theme.of(context).colorScheme.primary, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
  }
}