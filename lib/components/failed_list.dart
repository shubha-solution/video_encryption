import 'package:flutter/material.dart';

class Failed extends StatelessWidget {
  const Failed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
      return Container(
        decoration: BoxDecoration(color: Colors.white,),
        child: Text('Failed'),
      );
    },);
  }
}