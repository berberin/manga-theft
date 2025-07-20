import 'package:manga_theft/app/data/model/manga_meta_combine.dart';

class RecentArgs {
  final MangaMetaCombine mangaMetaCombine;
  final DateTime dateTime;
  final String chapterName;

  RecentArgs({
    required this.mangaMetaCombine,
    required this.dateTime,
    required this.chapterName,
  });
}
