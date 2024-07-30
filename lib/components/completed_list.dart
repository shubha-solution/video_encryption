import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});
    Future<void> _showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
      return Container(

        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
          ),
        child: InkWell

        (
          onTap: (){
 _showMyDialog(context);
},
          child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: const Text('29-07-24 | 10 videos'),
        )),
      );
    },);
  }
}