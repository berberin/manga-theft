import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';

part 'recent_read.g.dart';

@HiveType(typeId: 3)
class RecentRead extends Equatable {
  @HiveField(0)
  final MangaMeta mangaMeta;
  @HiveField(1)
  final DateTime dateTime;

  const RecentRead(this.mangaMeta, this.dateTime);

  @override
  // TODO: implement props
  List<Object> get props => [mangaMeta.preId];
}
