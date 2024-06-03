import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/gwidget/manga_frame.dart';
import 'package:manga_theft/app/modules/manga_detail/manga_detail_screen.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

import 'recent_agrs.dart';

class RecentCard extends StatelessWidget {
  final RecentArgs recentArgs;

  const RecentCard({Key? key, required this.recentArgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => MangaDetailScreen(
            metaCombine: recentArgs.mangaMetaCombine,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              )
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    recentArgs.mangaMetaCombine.mangaMeta.imgUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 16, bottom: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        MangaFrame(
                          imageUrl:
                              recentArgs.mangaMetaCombine.mangaMeta.imgUrl ??
                                  '',
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: spacer.withOpacity(0.7),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(1),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            child: Text(
                              recentArgs.mangaMetaCombine.mangaMeta.lang,
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recentArgs.mangaMetaCombine.mangaMeta.title ??
                                      '',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  recentArgs
                                          .mangaMetaCombine.mangaMeta.author ??
                                      '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    recentArgs.mangaMetaCombine.mangaMeta
                                            .description ??
                                        '',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black26,
                              endIndent: 5,
                              indent: 5,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'lastRead'.tr + recentArgs.chapterName,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  timeCalculate(recentArgs.dateTime),
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String timeCalculate(DateTime dateTime) {
    var diffTime = DateTime.now().difference(dateTime);
    if (diffTime.inMinutes < 60) {
      return diffTime.inMinutes.toString() + 'minutesAgo'.tr;
    } else if (diffTime.inHours < 24) {
      return diffTime.inHours.toString() + 'hoursAgo'.tr;
    } else if (diffTime.inDays < 7) {
      return diffTime.inDays.toString() + 'daysAgo'.tr;
    } else if (diffTime.inDays < 30) {
      return ((diffTime.inDays) ~/ 7).toString() + 'weeksAgo'.tr;
    } else if (diffTime.inDays < 365) {
      return ((diffTime.inDays) ~/ 30).toString() + 'monthsAgo'.tr;
    } else {
      return ((diffTime.inDays) ~/ 365).toString() + 'yearsAgo'.tr;
    }
  }
}
