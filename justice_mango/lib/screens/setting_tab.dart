import 'package:flutter/material.dart';
import 'package:justice_mango/app_theme.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/models/read_info.dart';
import 'package:justice_mango/providers/hive_provider.dart';

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
            ),
            ElevatedButton(
              onPressed: () {
                List<MangaMeta> mangasFavo = HiveProvider.getFavoriteMangas();
                ReadInfo infoFake =
                    HiveProvider.getLastReadInfo(mangaId: mangasFavo[0].id);
                infoFake.numberOfChapters = 1;
                HiveProvider.lastReadBox.put(mangasFavo[0].id, infoFake);
              },
              child: Text('fake update'),
            )
          ],
        ),
      ),
    );
  }
}
