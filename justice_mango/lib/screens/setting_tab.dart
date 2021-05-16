// SharedPreference stored info about current order in List of languages and sources (the order only)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle _textStyle = TextStyle(
  decoration: TextDecoration.none,
  color: Colors.black,
);

class SettingTab extends StatefulWidget {
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  List<String> _lan;
  List<String> _source;
  int _currentLan;
  int _currentSource;
  @override
  void initState() {
    super.initState();
    _loadLanguageSource();
  }

  _loadLanguageSource() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lan = ["Tiếng Việt", "English"];
      _source = ["nettruyen", "blogtruyen", "truyenqq"];
      _currentLan = (prefs.getInt("CurrentLan") ?? 0);
      _currentSource = (prefs.getInt("CurrentSource") ?? 0);
    });
  }

  _setLanguage(int current) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (current >= _lan.length - 1) {
        _currentLan = 0;
      } else {
        _currentLan += 1;
      }
      prefs.setInt("CurrentLan", _currentLan);
    });
  }

  _setSource(int current) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (current >= _source.length - 1) {
        _currentSource = 0;
      } else {
        _currentSource += 1;
      }
      prefs.setInt("CurrentSource", _currentSource);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            _buildLogo(),
            _buildRow("language"),
            _buildRow("source"),
          ],
        ),
      ),
    );
  }

  // ________________________________________________________________________________

  // build logo
  Widget _buildLogo() {
    return SafeArea(
      child: Container(
        height: 200,
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            child: Image.asset("assets/icons/icon.png"),
          ),
        ),
      ),
    );
  }

  // ________________________________________________________________________________

  // String button = "language" or "source"
  Widget _buildRow(String button) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: TextButton(
        onPressed: () {
          if (button == "language") {
            _setLanguage(_currentLan);
          } else {
            _setSource(_currentSource);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            border: Border.all(
              color: Colors.blue,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    (button == "language") ? "Language" : "Source",
                    style: _textStyle,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    (button == "language")
                        ? _lan[_currentLan]
                        : _source[_currentSource],
                    style: _textStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
