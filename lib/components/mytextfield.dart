import 'package:flutter/material.dart';
import 'package:video_encryption/components/colorpage.dart';

class MyTextField extends StatelessWidget {
  final String heading;
  final String hintText;
  final String errorText;
  final double width;
  final void Function()? onTap;

  final TextEditingController controller;
  const MyTextField(
      {super.key,
      required this.width,
      required this.controller,
      required this.errorText,
      required this.heading,
      required this.onTap,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontFamily: 'Outfit-Medium',
            fontSize: 16,
          ),
        ),
        TextFormField(
          onTap: onTap,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: ColorPage.darkblue),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
        ),
      ],
    );
  }
}
