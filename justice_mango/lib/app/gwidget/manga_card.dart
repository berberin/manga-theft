import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/modules/manga_detail/manga_detail_screen.dart';
import 'package:manga_theft/app/util/layout_constants.dart';

import 'manga_frame.dart';
import 'tag.dart';

class MangaCard extends StatelessWidget {
  final MangaMetaCombine metaCombine;

  const MangaCard({
    Key? key,
    required this.metaCombine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.toNamed(Routes.MANGA_DETAIL, arguments: {
        //   'metaCombine': metaCombine,
        // });
        Get.to(
          () => MangaDetailScreen(
            metaCombine: metaCombine,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(metaCombine.mangaMeta.imgUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: LayoutConstants.backcardMangaBoxDecoration,
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      MangaFrame(
                        imageUrl: metaCombine.mangaMeta.imgUrl ?? '',
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      // fixme: show language tag
                      // Positioned(
                      //   top: 5,
                      //   left: 5,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: spacer.withOpacity(0.7),
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(1)),
                      //     ),
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 8,
                      //       vertical: 0,
                      //     ),
                      //     child: Text(
                      //       metaCombine.mangaMeta.lang,
                      //       style: Get.textTheme.bodyText2?.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                metaCombine.mangaMeta.title ?? '',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                metaCombine.mangaMeta.author ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text(
                                  metaCombine.mangaMeta.description ?? '',
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          Tags(
                            tags: metaCombine.mangaMeta.tags ?? [],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
