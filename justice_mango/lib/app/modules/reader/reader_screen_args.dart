import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';

class ReaderScreenArgs {
  final List<String> preloadUrl;
  final MangaMetaCombine metaCombine;
  final List<ChapterInfo> chaptersInfo;
  final int index;

  ReaderScreenArgs({this.preloadUrl, this.metaCombine, this.chaptersInfo, this.index});
}
