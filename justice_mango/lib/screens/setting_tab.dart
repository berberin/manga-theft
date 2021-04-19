import 'package:flutter/material.dart';
import 'package:justice_mango/app_theme.dart';

class SettingTab extends StatefulWidget {
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  bool checkedValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text("Tuỳ chọn"),
            CheckboxListTile(
              title: Text("vi_nettruyen"),
              value: checkedValue,
              onChanged: (value) {
                setState(() {
                  checkedValue = value;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            )
          ],
        ),
      ),
    );
  }
}
