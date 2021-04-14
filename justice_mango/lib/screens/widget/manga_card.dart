import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/screens/widget/manga_frame.dart';
import 'package:justice_mango/screens/widget/tags.dart';

import '../manga_detail_screen.dart';

class MangaCard extends StatelessWidget {
  final MangaMeta mangaMeta;

  const MangaCard({Key key, this.mangaMeta}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
              image: NetworkImage(mangaMeta.imgUrl),
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
                    imageUrl: mangaMeta.imgUrl,
                    width: MediaQuery.of(context).size.width / 4.5,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MangaDetail(mangaMeta: mangaMeta)),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mangaMeta.title,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  //mangaMeta.author == '' ? 'Chưa rõ tác giả' : mangaMeta.author,
                                  mangaMeta.author,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text(
                                    mangaMeta.description,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tags(
                            tags: mangaMeta.tags,
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
