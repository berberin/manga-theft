import 'package:justice_mango/app/data/model/manga_meta_combine.dart';

class RecentMetaCombine {
  final MangaMetaCombine mangaMetaCombine;
  final DateTime dateTime;
  final String chapterName;

  RecentMetaCombine({
    required this.mangaMetaCombine,
    required this.dateTime,
    required this.chapterName,
  });
}
