import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_encryption/components/colorpage.dart';

class MyTextField extends StatefulWidget {
  final String heading;
  final String hintText;
  final String errorText;
  final double width;
  final bool isenable;

  final void Function()? onTap;

  final TextEditingController controller;
  const MyTextField(
      {super.key,
      required this.width,
      required this.controller,
      required this.errorText,
      required this.heading,
      required this.onTap(),
      required this.isenable,
      required this.hintText});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  RxBool isReadOnly = true.obs;

  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.heading,
              style: const TextStyle(
                fontFamily: 'Outfit-Medium',
                fontSize: 16,
              ),
            ),
            // const SizedBox(width: 5,),
            IconButton(
                onPressed: () {
                  _showMyDialog(context, widget.heading,
                      "Do you want to Edit ${widget.heading}?");
                },
                icon: const Icon(
                  Icons.mode_edit_rounded,
                  size: 15,
                ))
          ],
        ),
        Obx(
          () => TextFormField(
            onEditingComplete: () {
              isReadOnly.value = true;
            },
            enabled: widget.isenable,
            readOnly: isReadOnly.value,
            // autofocus: true,
            // onTap: widget.onTap,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(color: ColorPage.darkblue),
            controller: widget.controller,
            decoration: InputDecoration(
              suffixIcon: widget.isenable
                  ? isReadOnly.value
                      ? null
                      : IconButton(
                          onPressed: () {
                            isReadOnly.value = true;
                          },
                          icon: const Icon(Icons.check_rounded))
                  : null,
              hintText: widget.hintText,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.errorText;
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Future<void> _showMyDialog(context, String title, String body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              TextButton(child: const Text('ok'), onPressed: () {

                widget.onTap!(); 
              isReadOnly.value = false;

                Get.back();
              })
            ]);
      },
    );
  }
}
