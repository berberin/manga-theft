import 'package:flutter/material.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/route/app_route.dart';
import 'package:manga_theft/app/theme/color_theme.dart';
import 'package:manga_theft/app/util/layout_constants.dart';
import 'package:manga_theft/di/injection.dart';

import 'manga_frame.dart';

class ShortMangaCard extends StatelessWidget {
  final MangaMetaCombine metaCombine;

  const ShortMangaCard({super.key, required this.metaCombine});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.6 * 255),
            offset: const Offset(4, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(metaCombine.mangaMeta.imgUrl ?? ''),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
            decoration: LayoutConstants.upwardMangaBoxDecoration,
            child: InkWell(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      MangaFrame(
                        imageUrl: metaCombine.mangaMeta.imgUrl ?? '',
                        height: MediaQuery.of(context).size.width / 2.67,
                      ),
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              metaCombine.mangaMeta.title ?? '',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            //mangaMeta.author != '' ? mangaMeta.author : 'Chưa rõ tác giả',
                            metaCombine.mangaMeta.author ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          // Tags(
                          //   tags: mangaMeta.tags,
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                // Get.toNamed(Routes.MANGA_DETAIL, arguments: {
                //   'metaCombine': metaCombine,
                // });
                getIt<AppRoute>().push(
                  MangaDetailRoute(
                    metaCombine: metaCombine,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
