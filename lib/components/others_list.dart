import 'package:flutter/material.dart';

class Others extends StatelessWidget {
  const Others({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
      return Container(
        decoration: BoxDecoration(color: Colors.white,),
        child: Text('Others'),
      );
    },);
  }
}