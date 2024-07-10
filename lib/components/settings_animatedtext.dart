import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:video_encryption/components/colorpage.dart';

class MyAnimatedText extends StatelessWidget {
  final double width;
  final List<String> text;
  const MyAnimatedText({super.key, required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      softWrap: true,
      maxLines: 5,
      style: TextStyle(
        fontSize: width * 0.045,
        fontFamily: 'AUTAS',
        color: ColorPage.darkblue,
      ),
      
      child: AnimatedTextKit(
         pause: const Duration(seconds: 4),
        repeatForever: true,
        isRepeatingAnimation: true,
        animatedTexts: text.map((textItem) => TyperAnimatedText(textItem,speed: const Duration(milliseconds: 150))).toList(),
      ),
    );
  }
}
