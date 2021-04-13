import 'package:flutter/material.dart';
import 'package:justice_mango/screens/home_screen.dart';

import 'app_theme.dart';
import 'providers/providers.dart';

void main() async {
  await Providers.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spinbot',
      theme: appThemeData,
      home: HomeScreen(),
    );
  }
}
