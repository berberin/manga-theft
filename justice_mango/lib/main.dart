import 'package:flutter/material.dart';
import 'package:justice_mango/screens/home_screen.dart';

import 'providers/providers.dart';

void main() async {
  await Providers.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Justice Mango',
      home: HomeScreen(),
    );
  }
}
