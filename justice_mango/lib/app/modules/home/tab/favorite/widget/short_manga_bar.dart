import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_screen.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

class ShortMangaBar extends StatelessWidget {
  final MangaMetaCombine metaCombine;
  final String latestChapter;
  const ShortMangaBar({Key key, this.metaCombine, this.latestChapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 4,
        bottom: 4,
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: nearlyWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
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
              child: Image.network(metaCombine.mangaMeta.imgUrl),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metaCombine.mangaMeta.title,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 15,
                        ),
                  ),
                  Text(
                    metaCombine.mangaMeta.author,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Divider(
                    endIndent: 8,
                  ),
                  Text(
                    latestChapter,
                    style: Get.textTheme.overline,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 4),
              width: 4,
              height: 56,
              color: nearlyBlue.withOpacity(0.4),
            ),
            Container(
              decoration: BoxDecoration(
                color: spacer.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(1)),
              ),
              padding: EdgeInsets.symmetric(
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
          Get.to(
            () => MangaDetailScreen(
              metaCombine: metaCombine,
            ),
          );
        },
      ),
    );
  }
}
