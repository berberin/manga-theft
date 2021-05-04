import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/route/routes.dart';

import 'manga_frame.dart';
import 'tag.dart';

class MangaCard extends StatelessWidget {
  final MangaMetaCombine metaCombine;

  const MangaCard({
    Key key,
    this.metaCombine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MangaDetail(mangaMeta: mangaMeta)),
        // );
        Get.toNamed(Routes.MANGA_DETAIL, arguments: {
          'metaCombine': metaCombine,
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
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
                image: NetworkImage(metaCombine.mangaMeta.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MangaFrame(
                      imageUrl: metaCombine.mangaMeta.imgUrl,
                      width: MediaQuery.of(context).size.width / 3,
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
                                  metaCombine.mangaMeta.title,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  metaCombine.mangaMeta.author,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text(
                                    metaCombine.mangaMeta.description,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ],
                            ),
                            Tags(
                              tags: metaCombine.mangaMeta.tags,
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
      ),
    );
  }
}
