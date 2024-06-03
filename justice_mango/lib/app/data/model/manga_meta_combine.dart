import 'package:equatable/equatable.dart';
import 'package:manga_theft/app/data/repository/manga_repository.dart';

import 'manga_meta.dart';

class MangaMetaCombine extends Equatable {
  final MangaRepository repo;
  final MangaMeta mangaMeta;

  const MangaMetaCombine(this.repo, this.mangaMeta);

  @override
  List<Object> get props => [mangaMeta.url];
}
