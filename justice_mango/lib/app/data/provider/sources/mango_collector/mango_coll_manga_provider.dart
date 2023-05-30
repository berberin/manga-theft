// ignore_for_file: overridden_fields

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/provider/manga_provider.dart';
import 'package:justice_mango/app/data/provider/sources/mango_collector/mango_coll_http_provider.dart';

import '../../../repository/http_repository.dart';

class MangoCollMangaProvider extends MangaProvider {
  @override
  final nametag = 'storynap';
  @override
  final locale = const Locale('vi', 'VN');
  HttpRepository? httpRepo;
  final baseUrl = 'https://mango.storynap.com';
  Map<String, String> defaultImageHeader = {
    "Referer": "https://www.nettruyen.com/"
  };

  MangoCollMangaProvider() {
    httpRepo = HttpRepository(MangoCollHttpProvider());
    httpRepo!.get('$baseUrl/nt/info').then((resp) {
      if (resp.statusCode == 200) {
        try {
          defaultImageHeader =
              Map<String, String>.from(resp.data['option']['imageHeader']);
        } catch (e) {
          //
        }
      }
    });
  }

  @override
  Future<List<ChapterInfo>> getChaptersInfo(MangaMeta mangaMeta) async {
    var resp = await httpRepo!.get('$baseUrl/nt/chapters/${mangaMeta.preId}');
    List<ChapterInfo> chapters = <ChapterInfo>[];
    for (var c in resp.data) {
      chapters.add(ChapterInfo.fromJson(c));
    }
    return chapters;
  }

  @override
  Future<List<MangaMeta>> getLatestManga({page = 1}) async {
    var resp = await httpRepo!.get('$baseUrl/nt/latest/$page');
    List<MangaMeta> metas = <MangaMeta>[];
    for (var meta in resp.data) {
      metas.add(MangaMeta.fromJson(meta));
    }
    return metas;
  }

  @override
  Future<MangaMeta> getLatestMeta(MangaMeta mangaMeta) async {
    return mangaMeta;
  }

  @override
  Future<List<String>> getPages(String chapterUrl) async {
    var resp = await httpRepo!.post('$baseUrl/nt/pages',
        data: FormData.fromMap({
          'sourceUrl': chapterUrl,
        }));
    return List<String>.from(resp.data);
  }

  @override
  Map<String, String> imageHeader() {
    return defaultImageHeader;
  }

  @override
  Future<List<MangaMeta>> initData() async {
    return List<MangaMeta>.empty();
  }

  @override
  Future<List<MangaMeta>> search(String searchString) async {
    var resp = await httpRepo!.post('$baseUrl/nt/search',
        data: FormData.fromMap({
          'searchTerm': searchString,
        }));
    List<MangaMeta> metas = <MangaMeta>[];
    for (var meta in resp.data) {
      metas.add(MangaMeta.fromJson(meta));
    }
    return metas;
  }

  @override
  Future<List<MangaMeta>> searchTag(String searchTag) {
    // TODO: implement searchTag
    throw UnimplementedError();
  }
}
