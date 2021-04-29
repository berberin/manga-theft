import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/provider/http_provider.dart';
import 'package:random_string/random_string.dart';

import 'manga_provider.dart';

class NettruyenMangaProvider extends MangaProvider {
  static const nametag = 'nettruyen';
  static const locale = Locale('vi', 'VN');
  Future<List<MangaMeta>> getLatestManga({page: 1}) async {
    var randomString = randomAlpha(3);
    var url = "http://www.nettruyen.com/tim-truyen?page=$page&r=$randomString";
    Response response = await HttpProvider.get(url);
    List<MangaMeta> mangaMetas = _getMangaFromDOM(response.data.toString());
    for (var meta in mangaMetas) {
      //await HiveProvider.addToMangaBox(meta);
    }
    return mangaMetas;
  }

  Future<List<MangaMeta>> getFavoriteUpdate() async {
    var result = <MangaMeta>[];
    //var favorite = HiveProvider.getFavoriteMangas();
    // for (var manga in favorite) {
    //   // await HiveProvider.updateLastReadInfo(
    //   //    mangaId: manga.id,
    //   //    updateStatus: true,
    //   //  );
    //   //  if (HiveProvider.getLastReadInfo(mangaId: manga.id).newUpdate) {
    //   //    result.add(manga);
    //   //  }
    // }
    return result;
  }

  List<MangaMeta> _getMangaFromDOM(String body) {
    var mangaMetas = <MangaMeta>[];
    var soup = Beautifulsoup(body);
    var items = soup.find_all("div.item");

    final regId = RegExp(r'\d+');
    final regAuthor = RegExp(r'Tác giả:</label>(.+?)</p>');
    final regTags = RegExp(r'Thể loại:</label>(.+?)</p>');
    final regStatus = RegExp(r'Tình trạng:</label>(.+?)</p>');
    final regAlias = RegExp(r'Tên khác:</label>(.+?)</p>');

    try {
      for (var item in items) {
        String title = item.querySelector("div.clearfix div.box_img").querySelector("a").attributes['title'];
        String imgUrl = "http:" + item.querySelector("div figure div a img").attributes['data-original'];
        String url = item.querySelector("div figure div a").attributes['href'];
        String description = item.querySelector("div.box_text").text;

        String mainInfo = item.querySelector("div.message_main").innerHtml;
        var ids = regId.allMatches(url);
        String id = ids.last.input.substring(ids.last.start, ids.last.end);

        var authors = regAuthor.firstMatch(mainInfo);
        String author;
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
          tags = tagsMatch.group(1).split(",");
          for (int i = 0; i < tags.length; i++) {
            tags[i] = tags[i].trim();
          }
        }

        var statusMatch = regStatus.firstMatch(mainInfo);
        String status;
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
          alias = aliasMatch.group(1).split(",");
          for (int i = 0; i < alias.length; i++) {
            alias[i] = alias[i].trim();
          }
        }

        MangaMeta mangaMeta = MangaMeta(
          title: title,
          url: url,
          imgUrl: imgUrl,
          id: id,
          alias: alias,
          author: author,
          tags: tags,
          description: description,
          status: status,
        );
        mangaMetas.add(mangaMeta);
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }

    return mangaMetas;
  }

  Future<List<ChapterInfo>> getChaptersInfo(String mangaId) async {
    List<ChapterInfo> chaptersInfo = <ChapterInfo>[];
    while (mangaId.length > 0) {
      String url =
          "http://www.nettruyen.com/Comic/Services/ComicService.asmx/ProcessChapterPreLoad?comicId=$mangaId&commentId=-1";
      var response = await HttpProvider.get(url);
      try {
        for (var item in response.data['chapters']) {
          ChapterInfo chapterInfo = ChapterInfo.fromJson(item);
          chaptersInfo.add(chapterInfo);
        }
        return chaptersInfo;
      } catch (e) {
        mangaId = mangaId.substring(0, mangaId.length - 1);
      }
    }
    return chaptersInfo;
  }

  Future<List<String>> getPages(String chapterUrl) async {
    List<String> pagesUrl = <String>[];
    if (chapterUrl.startsWith("/")) {
      chapterUrl = "http://www.nettruyen.com" + chapterUrl;
    }
    var response = await HttpProvider.get(chapterUrl);
    var soup = Beautifulsoup(response.data.toString());
    var pages = soup.find_all("div.page-chapter img");

    for (var page in pages) {
      if (page.attributes['data-original'].startsWith("/"))
        pagesUrl.add("http:" + page.attributes['data-original']);
      else
        pagesUrl.add(page.attributes['data-original']);
    }
    return pagesUrl;
  }

  Future<List<MangaMeta>> search(String searchString) async {
    var mangaMetas = <MangaMeta>[];
    if (searchString == "") return mangaMetas;
    searchString = searchString.toLowerCase();
    try {
      var url = "http://www.nettruyen.com/tim-truyen?keyword=$searchString";
      var response = await HttpProvider.get(url);
      mangaMetas = _getMangaFromDOM(response.data.toString());
      for (var meta in mangaMetas) {
        //await HiveProvider.addToMangaBox(meta);
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    // connectivity.none
    // List<MangaMeta> listFromDB = HiveProvider.mangaBox.values.where((element) {
    //   if (element.title.toLowerCase().contains(searchString)) {
    //     return true;
    //   }
    //   for (var alias in element.alias) {
    //     if (alias.toLowerCase().contains(searchString)) {
    //       return true;
    //     }
    //   }
    //   return false;
    // }).toList();

    // for (var meta in listFromDB) {
    //   if (!mangaMetas.contains(meta)) {
    //     mangaMetas.add(meta);
    //   }
    // }
    return mangaMetas;
  }

  Future<List<MangaMeta>> searchTag(String searchTag) {
    // return HiveProvider.mangaBox.values.where((element) {
    //   for (var tag in element.tags) {
    //     if (tag == searchTag) {
    //       return true;
    //     }
    //   }
    //   return false;
    // }).toList();
  }

  getRandomManga(String tag, int amount) {
    // List<MangaMeta> mangas = searchTag(tag);
    // mangas.shuffle();
    // return mangas.sublist(0, 5);
  }

  getMangaMeta(String mangaId) async {
    // return HiveProvider.getMangaMeta(mangaId);
  }

  addMangaMeta(MangaMeta mangaMeta) async {
    // return await HiveProvider.addToMangaBox(mangaMeta);
  }

  Future<bool> inMangaBox(String mangaId) async {
    // if (HiveProvider.getMangaMeta(mangaId) == null) {
    //   return false;
    // }
    return true;
  }
}
