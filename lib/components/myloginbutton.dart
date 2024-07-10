import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_encryption/components/clsfontsize.dart';
import 'package:video_encryption/components/colorpage.dart';
import 'package:video_encryption/routes/routes.dart';

class MyLoginButton extends StatelessWidget {
  final String mychild;
  MyLoginButton({super.key, required this.mychild});

  final double fontsize = ClsFontsize.DoubleExtraLarge + 2;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      hoverElevation: 5,
      hoverColor: ColorPage.darkbluelight,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.only(bottom: 15),
      color: ColorPage.colorgrey,
      onPressed: () {
        Get.toNamed(RoutesClass.settingspage);
      },
      // shubha
      child: Center(
        child: Text(
          mychild,
          style: TextStyle(fontSize: fontsize, color: ColorPage.white),
        ),
      ),
    );
  }
}
