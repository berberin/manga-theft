import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cubit/board/board_cubit.dart';

class SettingBottomSheet extends StatefulWidget {
  final BoardCubit boardCubit;

  const SettingBottomSheet({super.key, required this.boardCubit});

  @override
  SettingBottomSheetState createState() => SettingBottomSheetState();
}

class SettingBottomSheetState extends State<SettingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      child: SingleChildScrollView(
        child: Column(
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
            for (var locale in widget.boardCubit.sourceService.allLocalesSupported)
              CheckboxListTile(
                value: locale.languageCode == widget.boardCubit.sourceService.selectedLocale.languageCode,
                onChanged: (newValue) {
                  if (newValue ?? false) {
                    setState(() {
                      widget.boardCubit.sourceService.changeLocale(locale);
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
            for (var source in widget.boardCubit.sourceService.allSourceRepositories)
              CheckboxListTile(
                value: widget.boardCubit.sourceService.sourceRepositories.contains(source),
                onChanged: (newValue) {
                  if (newValue ?? false) {
                    setState(() {
                      widget.boardCubit.sourceService.addToSource(source);
                    });
                  } else {
                    setState(() {
                      widget.boardCubit.sourceService.removeSource(source);
                    });
                  }
                  widget.boardCubit.updateSources();
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
