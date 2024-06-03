import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_theft/app/theme/text_theme.dart';

ThemeData appThemeData = ThemeData.light().copyWith(
  textTheme: appTextTheme,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark, // 2
  ),
);
