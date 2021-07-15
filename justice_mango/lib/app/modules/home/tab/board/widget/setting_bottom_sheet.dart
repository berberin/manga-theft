import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_controller.dart';

class SettingBottomSheet extends StatefulWidget {
  const SettingBottomSheet({Key key}) : super(key: key);

  @override
  _SettingBottomSheetState createState() => _SettingBottomSheetState();
}

class _SettingBottomSheetState extends State<SettingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: Get.height / 2,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'language'.tr,
              style: Get.textTheme.headline5,
            ),
            SizedBox(
              height: 16,
            ),
            for (var locale in SourceService.allLocalesSupported)
              CheckboxListTile(
                value: locale.languageCode == SourceService.selectedLocale.languageCode,
                onChanged: (newValue) {
                  if (newValue) {
                    setState(() {
                      SourceService.changeLocale(locale);
                    });
                  }
                },
                title: Text(locale.fullName()),
              ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 10,
              endIndent: 40,
            ),
            Text(
              'sources'.tr,
              style: Get.textTheme.headline5,
            ),
            SizedBox(
              height: 16,
            ),
            for (var source in SourceService.allSourceRepositories)
              CheckboxListTile(
                value: SourceService.sourceRepositories.contains(source),
                onChanged: (newValue) {
                  if (newValue) {
                    setState(() {
                      SourceService.addToSource(source);
                    });
                  } else {
                    setState(() {
                      SourceService.removeSource(source);
                    });
                  }
                  BoardController boardController = Get.find();
                  boardController.updateSources();
                },
                title: Text(
                  source.slug,
                  style: GoogleFonts.inconsolata(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension FullName on Locale {
  String fullName() {
    switch (this.languageCode) {
      case 'en':
        return 'English';

      case 'vi':
        return 'Tiếng Việt';
    }
    return '';
  }
}
