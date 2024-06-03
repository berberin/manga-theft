// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';
import 'package:manga_theft/app/data/provider/sources/nettruyen/nettruyen_http_provider.dart';
import 'package:manga_theft/app/data/repository/http_repository.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:random_string/random_string.dart';

import '../../manga_provider.dart';

class NettruyenMangaProvider extends MangaProvider {
  // @override
  // final nametag = 'nettruyen';

  //change nametag nettruyen to storynap
  @override
  final nametag = 'storynap';
  @override
  final locale = const Locale('vi', 'VN');
  final httpRepo = HttpRepository(NettruyenHttpProvider());
  final baseUrl = 'www.nettruyen.com';

  @override
  Future<List<MangaMeta>> getLatestManga({page = 1}) async {
    var randomString = randomAlpha(3);
    var url = "https://$baseUrl/tim-truyen?page=$page&r=$randomString";
    Response response = await httpRepo.get(url);
    List<MangaMeta> mangaMetas = _getMangaFromDOM(response.data.toString());

    return mangaMetas;
  }

  List<MangaMeta> _getMangaFromDOM(String body) {
    var mangaMetas = <MangaMeta>[];
    var soup = BeautifulSoup(body);
    var items = soup.findAll("div.item");

    final regId = RegExp(r'\d+');
    final regAuthor = RegExp(r'Tác giả:</label>(.*?)</p>');
    final regTags = RegExp(r'Thể loại:</label>(.*?)</p>');
    final regStatus = RegExp(r'Tình trạng:</label>(.*?)</p>');
    final regAlias = RegExp(r'Tên khác:</label>(.*?)</p>');

    try {
      for (var item in items) {
        String title = item
            .find('', selector: "div.clearfix div.box_img")
            ?.find('a')
            ?.attributes['title'] ??
            '';

        String imgUrl =
            "http:${item
            .find("div figure div a img")
            ?.attributes['data-original'] ?? ''}";
        String url = item
            .find("div figure div a")
            ?.attributes['href'] ?? '';
        String description = item
            .find("div.box_text")
            ?.text ?? '';

        String mainInfo = item
            .find("div.message_main")
            ?.innerHtml ?? '';
        var ids = regId.allMatches(url);
        String id = ids.last.input.substring(ids.last.start, ids.last.end);

        var authors = regAuthor.firstMatch(mainInfo);
        String? author;
        if (authors == null) {
          author = "";
        } else {
          author = authors.group(1);
        }

        var tagsMatch = regTags.firstMatch(mainInfo);
        List<String> tags;
        if (tagsMatch == null) {
          tags = [];
        } else {
          tags = tagsMatch.group(1)?.split(",") ?? [];
          for (int i = 0; i < tags.length; i++) {
            tags[i] = tags[i].trim();
          }
        }

        var statusMatch = regStatus.firstMatch(mainInfo);
        String? status;
        if (statusMatch == null) {
          status = "Không rõ";
        } else {
          status = statusMatch.group(1);
        }

        var aliasMatch = regAlias.firstMatch(mainInfo);
        List<String> alias;
        if (aliasMatch == null) {
          alias = [];
        } else {
          alias = aliasMatch.group(1)?.split(",") ?? [];
          for (int i = 0; i < alias.length; i++) {
            alias[i] = alias[i].trim();
          }
        }

        MangaMeta mangaMeta = MangaMeta(
          title: title,
          url: url,
          imgUrl: imgUrl,
          preId: id,
          alias: alias,
          author: author,
          tags: tags,
          description: description,
          status: status,
          lang: 'vi',
          repoSlug: slug,
        );
        mangaMetas.add(mangaMeta);
      }
    } catch (e) {
      //
    }

    return mangaMetas;
  }

  Future<MangaMeta> _getSingleMangaMetaFromUrl(MangaMeta oldMangaMeta) async {
    var response = await httpRepo.get(oldMangaMeta.url);
    var soup = BeautifulSoup(response.data.toString());

    String title = soup
        .find('', selector: "h1.title-detail")
        ?.text ?? '';

    String imgUrl =
        "http:${soup
        .find("div.col-xs-4.col-image")
        ?.find("img")
        ?.attributes['src'] ?? '//picsum.photos/200/400'}";
    String description = soup
        .find("div.detail-content p")
        ?.text ?? '';

    MangaMeta mangaMeta = MangaMeta(
      title: title,
      url: oldMangaMeta.url,
      imgUrl: imgUrl,
      preId: oldMangaMeta.preId,
      alias: oldMangaMeta.alias,
      author: oldMangaMeta.author,
      tags: oldMangaMeta.tags,
      description: description,
      status: oldMangaMeta.status,
      lang: 'vi',
      repoSlug: slug,
    );
    return mangaMeta;
  }

  @override
  Future<List<ChapterInfo>> getChaptersInfo(MangaMeta mangaMeta) async {
    List<ChapterInfo> chaptersInfo = <ChapterInfo>[];
    String mangaId = mangaMeta.preId;
    while (mangaId.isNotEmpty) {
      // String url =
      //     "https://$baseUrl/Comic/Services/ComicService.asmx/ProcessChapterPreLoad?comicId=$mangaId&commentId=-1";
      var response = await httpRepo.get(mangaMeta.url);
      try {
        var soup = BeautifulSoup(response.data.toString());
        var chapters = soup.findAll("div.col-xs-5.chapter");
        // for (var item in response.data['chapters']) {
        //   ChapterInfo chapterInfo = ChapterInfo.fromJson(item);
        //   chaptersInfo.add(chapterInfo);
        // }
        for (var chapter in chapters) {
          chaptersInfo.add(
            ChapterInfo(
              preChapterId: chapter.a?.attributes['data-id'] ?? '',
              name: chapter.a?.text ?? 'nhân cách của igl',
              url: chapter.a?.attributes['href'],
            ),
          );
        }
        return chaptersInfo;
      } catch (e) {
        mangaId = mangaId.substring(0, mangaId.length - 1);
      }
    }
    return chaptersInfo;
  }

  @override
  Future<List<String>> getPages(String chapterUrl) async {
    List<String> pagesUrl = <String>[];
    if (chapterUrl.startsWith("/")) {
      chapterUrl = "https://$baseUrl$chapterUrl";
    }
    var response = await httpRepo.get(chapterUrl);
    var soup = BeautifulSoup(response.data.toString());
    var pages = soup.findAll("div.page-chapter img");

    for (var page in pages) {
      if (page.attributes['data-original']?.startsWith("/") ?? false) {
        pagesUrl.add("http:${page.attributes['data-original']!}");
      } else {
        pagesUrl.add(page.attributes['data-original'] ?? '');
      }
    }
    return pagesUrl;
  }

  @override
  Future<List<MangaMeta>> search(String searchString) async {
    var mangaMetas = <MangaMeta>[];
    if (searchString == "") return mangaMetas;
    searchString = searchString.toLowerCase();
    try {
      var url = "https://$baseUrl/tim-truyen?keyword=$searchString";
      var response = await httpRepo.get(url);
      mangaMetas = _getMangaFromDOM(response.data.toString());
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
    }
    return mangaMetas;
  }

  @override
  Future<List<MangaMeta>> searchTag(String searchTag) async {
    // TODO: get from source provider
    return HiveService.mangaBox.values.where((element) {
      for (var tag in element.tags ?? []) {
        if (tag == searchTag) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  @override
  Future<List<MangaMeta>> initData() async {
    String assetsStr = 'assets/data/nettruyen_data.json';
    String jsonString = await rootBundle.loadString(assetsStr);
    List<dynamic> jsonArr = jsonDecode(jsonString);
    return List<MangaMeta>.generate(
        jsonArr.length, (index) => MangaMeta.fromJson(jsonArr[index]));
  }

  @override
  Map<String, String> imageHeader() {
    return {"Referer": "https://$baseUrl/"};
  }

  @override
  Future<MangaMeta> getLatestMeta(MangaMeta mangaMeta) async {
    // TODO: implement full version of getLatestMeta // copyWith
    MangaMeta latestMangaMeta = await _getSingleMangaMetaFromUrl(mangaMeta);
    return latestMangaMeta;
  }
}
