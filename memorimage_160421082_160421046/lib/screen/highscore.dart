import 'package:flutter/material.dart';

class  HighScore extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text('HighScore'),
   ),
   body: Center(
    child: Image.network("https://i.pravatar.cc/150"),
   ),
  );
 }
}
