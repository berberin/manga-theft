import 'package:justice_mango/app/data/repository/manga_repository.dart';

import 'manga_meta.dart';

class MangaMetaCombine {
  final MangaRepository repo;
  final MangaMeta mangaMeta;

  MangaMetaCombine(this.repo, this.mangaMeta);
}
