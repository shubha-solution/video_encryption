
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_encryption/components/clsfontsize.dart';
import 'package:video_encryption/components/colorpage.dart';

class FontFamily {
  static var font = GoogleFonts.outfit(
      textStyle: TextStyle(
          color: ColorPage.colorgrey,
          fontSize: ClsFontsize.Small,
          fontWeight: FontWeight.bold));
  // used in -->
  //forgetPasswordMobile
  // Mobilelogin
  //signInOtpScreen
  //ForgotScreen
  //HomePage
  //DthLmsLogin
  //OTPScreen
  //Profile

  static var font2 = GoogleFonts.outfit(
      textStyle: TextStyle(
          color: ColorPage.white,
          fontSize: ClsFontsize.ExtraSmall,
          fontWeight: FontWeight.bold));
  //used in -->
  //signInOtpScreen
  //OTPScreen
  //MyClassDashboard
  //MyClassContent
  //Profile
  //StudyDashboard
  //StudyMaterialPdf
  //StudyMaterialDashboard
  //Dashboard

  static var mobilefont = GoogleFonts.outfit(
      textStyle: TextStyle(
          color: ColorPage.colorgrey,
          fontSize: ClsFontsize.ExtraSmall,
          fontWeight: FontWeight.bold));
  //used in -->
  //Mobilelogin
  //DthLmsLogin
  //StudyMaterialPdf
  //StudyMaterialDashboard

  static var font3 = GoogleFonts.outfit(
      textStyle:
          TextStyle(color: Colors.white, fontSize: ClsFontsize.ExtraSmall));
  //used in -->
  //forgetPasswordMobile
  //signInOtpScreen
  //ForgotScreen
  //OTPScreen
  //ButtonWidget

  static var font4 = GoogleFonts.outfit(
      textStyle: TextStyle(
          color: ColorPage.colorblack, fontSize: ClsFontsize.ExtraSmall - 2));
  //used in -->
  //MobileHomepage
  //signInOtpScreen
  //MyClassVideoContent

  static var font5 = GoogleFonts.outfit(
      textStyle:
          TextStyle(color: ColorPage.white, fontSize: ClsFontsize.ExtraLarge));
  //used in -->
  //MobileHomepage

  static var font6 = GoogleFonts.outfit(
      textStyle: TextStyle(
          color: ColorPage.colorblack, fontSize: ClsFontsize.Large - 2));
  //used in -->
  //MobileHomepage

  static var font7 = GoogleFonts.outfit(
      textStyle:
          TextStyle(color: ColorPage.white, fontSize: ClsFontsize.Large - 2));
  //not in use

  // ignore: non_constant_identifier_names
  static var ResendOtpfont = GoogleFonts.outfit(
      textStyle: TextStyle(
          color: ColorPage.red,
          fontSize: ClsFontsize.ExtraSmall,
          fontWeight: FontWeight.bold));
  //used in -->
  //signInOtpScreen
}