import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

import '../../../../../../di/injection.dart';
import '../../../../../route/app_route.dart';

class ShortMangaBar extends StatelessWidget {
  final MangaMetaCombine metaCombine;
  final String latestChapter;

  const ShortMangaBar({super.key, required this.metaCombine, this.latestChapter = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 4,
        bottom: 4,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: nearlyWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.6 * 255),
            offset: const Offset(2, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
        child: Row(
          children: [
            SizedBox(
              height: 48,
              child: Image.network(metaCombine.mangaMeta.imgUrl ?? ''),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metaCombine.mangaMeta.title ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 15,
                        ),
                  ),
                  Text(
                    metaCombine.mangaMeta.author ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(
                    endIndent: 8,
                  ),
                  Text(
                    latestChapter,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 4),
              width: 4,
              height: 56,
              color: nearlyBlue.withValues(alpha: 0.4 * 255),
            ),
            Container(
              decoration: BoxDecoration(
                color: spacer.withValues(alpha: 0.7 * 255),
                borderRadius: const BorderRadius.all(Radius.circular(1)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 0,
              ),
              child: Text(
                metaCombine.mangaMeta.lang,
                style: GoogleFonts.inconsolata().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          getIt<AppRoute>().push(
            MangaDetailRoute(metaCombine: metaCombine),
          );
        },
      ),
    );
  }
}
