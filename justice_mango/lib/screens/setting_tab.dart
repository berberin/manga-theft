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
              onPressed: () async {
                List<MangaMeta> mangasFavo = HiveProvider.getFavoriteMangas();
                ReadInfo infoFake = HiveProvider.getLastReadInfo(mangaId: mangasFavo[0].id);
                infoFake.numberOfChapters = 1;
                HiveProvider.lastReadBox.put(mangasFavo[0].id, infoFake);

                // do thay đổi ở hàm update info, ta phải đánh dấu chương mới nhất đã được đọc
                // khi set numberOfChapters = 1 ---> tức là ta phải đánh dấu chương cuối cùng trong danh sách chương
                var chapterList = await MangaProvider.getChaptersInfo(mangasFavo[0].id);
                await HiveProvider.addToReadBox(chapterList.last);
              },
              child: Text('fake update'),
            ),
            ElevatedButton(
              onPressed: () async {
                List<MangaMeta> mangasFavo = await MangaProvider.getFavoriteUpdate();
                print(mangasFavo.first.toJson());
              },
              child: Text('check update'),
            ),
          ],
        ),
      ),
    );
  }
}
