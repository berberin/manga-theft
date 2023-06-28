import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_controller.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_provider.dart';

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
      constraints: const BoxConstraints(
        maxHeight: 24,
      ),
      child: SingleChildScrollView(
        child: Consumer(
          builder: (context, ref, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'language'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
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
                  'sources'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
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
                      // BoardController boardController = Get.find();
                      ref.read(boardProvider.notifier).updateSources();
                    },
                    title: Text(
                      source.slug,
                      style: GoogleFonts.inconsolata(),
                    ),
                  ),
              ],
            );
          },
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
