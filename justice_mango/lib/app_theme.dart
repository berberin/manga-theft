import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//const String fontFamily = 'Montserrat';
const TextStyle display1 = TextStyle(
  // h4 -> display1
  //fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 36,
  letterSpacing: 0.4,
  height: 0.9,
  color: darkerText,
);

const TextStyle headline = TextStyle(
  // h5 -> headline
  //fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 24,
  letterSpacing: 0.27,
  color: darkerText,
);

const TextStyle title = TextStyle(
  // h6 -> title
  //fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 16,
  letterSpacing: 0.18,
  color: darkerText,
);

const TextStyle subtitle = TextStyle(
  // subtitle2 -> subtitle
  //fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 14,
  letterSpacing: -0.04,
  color: darkText,
);

const TextStyle body2 = TextStyle(
  // body1 -> body2
  //fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 14,
  letterSpacing: 0.2,
  color: darkText,
);

const TextStyle body1 = TextStyle(
  // body2 -> body1
  //fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 16,
  letterSpacing: -0.05,
  color: darkText,
);

const TextStyle caption = TextStyle(
  // Caption -> caption
  //fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 12,
  letterSpacing: 0.2,
  color: lightText, // was lightText
);

TextTheme appTextTheme = GoogleFonts.openSansTextTheme().merge(TextTheme(
  headline4: display1,
  headline5: headline,
  headline6: title,
  subtitle2: subtitle,
  bodyText2: body2,
  bodyText1: body1,
  caption: caption,
));

ThemeData appThemeData = ThemeData.light().copyWith(
  textTheme: appTextTheme,
);

const Color mainColor = Color(0xFF043336);
const Color notWhite = Color(0xFFEDF0F2);
const Color nearlyWhite = Color(0xFFFEFEFE);
const Color white = Color(0xFFFFFFFF);
const Color nearlyBlack = Color(0xFF213333);
const Color grey = Color(0xFF3A5160);
const Color dark_grey = Color(0xFF313A44);

const Color darkText = Color(0xFF253840);
const Color darkerText = Color(0xFF17262A);
const Color lightText = Color(0xFF4A6572);
const Color deactivatedText = Color(0xFF767676);
const Color dismissibleBackground = Color(0xFF364A54);
const Color chipBackground = Color(0xFFEEF1F3);
const Color spacer = Color(0xFFF2F2F2);
