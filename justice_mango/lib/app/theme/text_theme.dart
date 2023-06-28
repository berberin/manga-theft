import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_theme.dart';

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

extension ThemeExtension on BuildContext {
  TextStyle get display1 {
    return display1;
  }
}

TextTheme appTextTheme = GoogleFonts.nunitoTextTheme().merge(const TextTheme(
  headlineMedium: display1,
  headlineSmall: headline,
  titleLarge: title,
  titleSmall: subtitle,
  bodyMedium: body2,
  bodyLarge: body1,
  bodySmall: caption,
));
