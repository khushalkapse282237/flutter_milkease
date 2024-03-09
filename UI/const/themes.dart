import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes{
  static Color mainColor = const Color(0xFF06F606);
  static Color accentColor = Colors.greenAccent;
  static Color lightColor = Colors.white;
  static Color darkColor = Colors.black;
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 24,
        color: Themes.darkColor,
        fontWeight: FontWeight.bold,
      )
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
      textStyle:TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Themes.darkColor,
      )
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Themes.darkColor,
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
        color: Themes.darkColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ));
}

TextStyle get bodyStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
        color: Themes.darkColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ));
}

TextStyle get body2Style {
  return GoogleFonts.lato(
      textStyle: TextStyle(
        color: Themes.darkColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ));
}