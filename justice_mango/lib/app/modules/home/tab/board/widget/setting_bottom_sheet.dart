import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_theft/app/data/service/source_service.dart';
import 'package:manga_theft/app/modules/home/tab/board/board_controller.dart';

class SettingBottomSheet extends StatefulWidget {
  const SettingBottomSheet({Key? key}) : super(key: key);

  @override
  SettingBottomSheetState createState() => SettingBottomSheetState();
}

class SettingBottomSheetState extends State<SettingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 16,
            ),
            for (var locale in SourceService.allLocalesSupported)
              CheckboxListTile(
                value: locale.languageCode ==
                    SourceService.selectedLocale.languageCode,
                onChanged: (newValue) {
                  if (newValue ?? false) {
                    setState(() {
                      SourceService.changeLocale(locale);
                    });
                  }
                },
                title: Text(locale.fullName()),
              ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              height: 10,
              endIndent: 40,
            ),
            Text(
              'sources'.tr,
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 16,
            ),
            for (var source in SourceService.allSourceRepositories)
              CheckboxListTile(
                value: SourceService.sourceRepositories.contains(source),
                onChanged: (newValue) {
                  if (newValue ?? false) {
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
    switch (languageCode) {
      case 'en':
        return 'English';

      case 'vi':
        return 'Tiếng Việt';
    }
    return '';
  }
}
