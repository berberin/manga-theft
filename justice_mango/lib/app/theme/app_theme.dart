import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:justice_mango/app/theme/text_theme.dart';

ThemeData appThemeData = ThemeData.light().copyWith(
  textTheme: appTextTheme,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark, // 2
  ),
);
