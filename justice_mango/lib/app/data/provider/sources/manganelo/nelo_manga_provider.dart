// import 'dart:convert';
//
// import 'package:beautiful_soup_dart/beautiful_soup.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:manga_theft/app/data/model/chapter_info.dart';
// import 'package:manga_theft/app/data/model/manga_meta.dart';
// import 'package:manga_theft/app/data/provider/manga_provider.dart';
// import 'package:manga_theft/app/data/repository/http_repository.dart';
// import 'package:manga_theft/app/data/service/hive_service.dart';
// import 'package:random_string/random_string.dart';
//
// import 'nelo_http_provider.dart';
//
// class NeloMangaProvider extends MangaProvider {
//   final nametag = 'manganelo';
//   final locale = Locale('en', 'US');
//   final httpRepo = HttpRepository(NeloHttpProvider());
//
//   @override
//   Future<List<MangaMeta>> getLatestManga({page = 1}) async {
//     var randomString = randomAlpha(3);
//     var url = "https://manganelo.com/genre-all/$page?r=$randomString";
//     Response response = await httpRepo.get(url);
//     List<MangaMeta> mangaMetas =
//         await _getMangaFromDOM(response.data.toString());
//     // TODO: description
//     return mangaMetas;
//   }
//
//   @override
//   Future<List<ChapterInfo>> getChaptersInfo(MangaMeta mangaMeta) async {
//     Response response = await httpRepo.get(mangaMeta.url);
//     List<ChapterInfo> chapters = _getChaptersFromDOM(response.data.toString());
//     return chapters;
//   }
//
//   @override
//   Future<List<String>> getPages(String chapterUrl) async {
//     Response response = await httpRepo.get(chapterUrl);
//     List<String> result = <String>[];
//     var soup = BeautifulSoup(response.data.toString());
//     var items = soup.findAll("div.container-chapter-reader img");
//     for (var item in items) {
//       result.add(item.attributes['src'] ?? '');
//     }
//     return result;
//   }
//
//   @override
//   Map<String, String> imageHeader() {
//     return {
//       "Referer": "https: //manganelo.com/",
//     };
//   }
//
//   @override
//   Future<List<MangaMeta>> initData() async {
//     String assetsStr = 'assets/data/manganelo_data.json';
//     String jsonString = await rootBundle.loadString(assetsStr);
//     List<dynamic> jsonArr = jsonDecode(jsonString);
//     return List<MangaMeta>.generate(
//         jsonArr.length, (index) => MangaMeta.fromJson(jsonArr[index]));
//   }
//
//   @override
//   Future<List<MangaMeta>> search(String searchString) async {
//     List<MangaMeta> mangaMetas = <MangaMeta>[];
//     if (searchString == "") return mangaMetas;
//     searchString = searchString.toLowerCase().replaceAll(" ", "_");
//     try {
//       String url = "https://manganelo.com/search/story/$searchString";
//       var response = await httpRepo.get(url);
//       // TODO: fix
//       mangaMetas = await _getMangaFromDOMSearch(response.data.toString());
//     } catch (e, stacktrace) {
//       print(e);
//       print(stacktrace);
//     }
//     return mangaMetas;
//   }
//
//   @override
//   Future<List<MangaMeta>> searchTag(String searchTag) async {
//     // TODO: implement searchTag
//     return HiveService.mangaBox.values.where((element) {
//       for (var tag in element.tags ?? []) {
//         if (tag == searchTag) {
//           return true;
//         }
//       }
//       return false;
//     }).toList();
//   }
//
//   List<ChapterInfo> _getChaptersFromDOM(String body) {
//     var chaptersInfo = <ChapterInfo>[];
//     var soup = BeautifulSoup(body);
//     var items = soup.findAll("a.chapter-name");
//     for (var item in items) {
//       chaptersInfo.add(
//         ChapterInfo(
//           url: item.attributes['href'],
//           preChapterId: item.attributes['href'].hashCode.toString(),
//           name: item.text,
//         ),
//       );
//     }
//     return chaptersInfo;
//   }
//
//   Future<List<MangaMeta>> _getMangaFromDOM(String body) async {
//     var mangaMetas = <MangaMeta>[];
//     var soup = BeautifulSoup(body);
//     var items = soup.findAll("div.content-genres-item");
//
//     final regId = RegExp(r'manga(.+)$', multiLine: true);
//     final regAlias =
//         RegExp(r'info-alternative.*</td>.+<h2>(.*?)</h2>', dotAll: true);
//     final regStatus = RegExp(r'info-status.*</td>\s*.+>(.*)</td>');
//     final regGenres = RegExp(r'info-genres.+</td>(.+</td>)', dotAll: true);
//
//     for (var item in items) {
//       // process item => mangaMeta
//
//       try {
//         var titleItem = item.find("a.genres-item-img");
//         String title = titleItem?.attributes['title'] ?? '';
//         String url = titleItem?.attributes['href'] ?? '';
//         String id = regId.firstMatch(url)?.group(1) ?? '';
//
//         String imgUrl = item.find("img.img-loading")?.attributes['src'] ?? '';
//         //String description = item.querySelector("div.genres-item-description").text;
//         String author = item.find("span.genres-item-author")?.text ?? '';
//
//         // note: trick giảm thời gian chờ
//         // note: don't work in isolate (hivedb)
//         // if (HiveService.hasMangaMeta(slug + id)) {
//         //   mangaMetas.add(HiveService.getMangaMeta(slug + id));
//         //   continue;
//         // } else {
//         try {
//           if (HiveService.hasMangaMeta(slug + id)) {
//             mangaMetas.add(HiveService.getMangaMeta(slug + id));
//             continue;
//           }
//         } catch (e) {}
//         // retrieve info from network
//         Response response = await httpRepo.get(url);
//         String body = response.data.toString();
//         var soupDescription = BeautifulSoup(body);
//         String description = soupDescription
//             .findAll("div.panel-story-info-description")
//             .elementAt(0)
//             .text;
//
//         var aliasesMatch = regAlias.firstMatch(body);
//         List<String> aliases = [];
//         if (aliasesMatch == null) {
//           aliases = [];
//         } else {
//           aliases = aliasesMatch.group(1)?.split(";") ?? [];
//           for (int i = 0; i < aliases.length; i++) {
//             aliases[i] = aliases[i].trim();
//           }
//         }
//
//         String status = regStatus.firstMatch(body)?.group(1) ?? "Unknown";
//
//         var genresMatch = regGenres.firstMatch(body);
//         List<String> tags = [];
//         if (genresMatch == null) {
//         } else {
//           var soup2 = BeautifulSoup(genresMatch.group(1) ?? '');
//           var genres = soup2.findAll("a.a-h");
//           for (var genre in genres) {
//             tags.add(genre.text);
//           }
//         }
//
//         MangaMeta mangaMeta = MangaMeta(
//           title: title,
//           url: url,
//           imgUrl: imgUrl,
//           preId: id,
//           alias: aliases,
//           author: author,
//           tags: tags,
//           description: description,
//           status: status,
//           lang: locale.languageCode,
//           repoSlug: slug,
//         );
//         mangaMetas.add(mangaMeta);
//         //}
//       } catch (e, stacktrace) {
//         print(e);
//         print(stacktrace);
//         continue;
//       }
//     }
//     return mangaMetas;
//   }
//
//   Future<List<MangaMeta>> _getMangaFromDOMSearch(String body) async {
//     var mangaMetas = <MangaMeta>[];
//     var soup = BeautifulSoup(body);
//     var items = soup.findAll("div.search-story-item");
//
//     final regId = RegExp(r'manga(.+)$', multiLine: true);
//     final regAlias =
//         RegExp(r'info-alternative.*</td>.+<h2>(.*?)</h2>', dotAll: true);
//     final regStatus = RegExp(r'info-status.*</td>\s*.+>(.*)</td>');
//     final regGenres = RegExp(r'info-genres.+</td>(.+</td>)', dotAll: true);
//
//     for (var item in items) {
//       // process item => mangaMeta
//
//       try {
//         var titleItem = item.find("a.item-img");
//         String title = titleItem?.attributes['title'] ?? '';
//         String url = titleItem?.attributes['href'] ?? '';
//         String id = regId.firstMatch(url)?.group(1) ?? '';
//
//         String imgUrl = item.find("img.img-loading")?.attributes['src'] ?? '';
//         //String description = item.querySelector("div.genres-item-description").text;
//         String author = item.find("span.tem-author")?.text ?? '';
//
//         // note: trick giảm thời gian chờ
//         if (HiveService.hasMangaMeta(slug + id)) {
//           mangaMetas.add(HiveService.getMangaMeta(slug + id));
//           continue;
//         } else {
//           // retrieve info from network
//           Response response = await httpRepo.get(url);
//           String body = response.data.toString();
//           var aliasesMatch = regAlias.firstMatch(body);
//           List<String> aliases = [];
//           if (aliasesMatch == null) {
//             aliases = [];
//           } else {
//             aliases = aliasesMatch.group(1)?.split(";") ?? [];
//             for (int i = 0; i < aliases.length; i++) {
//               aliases[i] = aliases[i].trim();
//             }
//           }
//
//           String status = regStatus.firstMatch(body)?.group(1) ?? "Unknown";
//
//           var genresMatch = regGenres.firstMatch(body);
//           List<String> tags = [];
//           if (genresMatch == null) {
//           } else {
//             var soup2 = BeautifulSoup(genresMatch.group(1) ?? '');
//             var genres = soup2.findAll("a.a-h");
//             for (var genre in genres) {
//               tags.add(genre.text);
//             }
//           }
//
//           var soupDescription = BeautifulSoup(body);
//           String description = soupDescription
//               .findAll("div.panel-story-info-description")
//               .elementAt(0)
//               .text;
//
//           MangaMeta mangaMeta = MangaMeta(
//             title: title,
//             url: url,
//             imgUrl: imgUrl,
//             preId: id,
//             alias: aliases,
//             author: author,
//             tags: tags,
//             description: description,
//             status: status,
//             lang: locale.languageCode,
//             repoSlug: slug,
//           );
//           mangaMetas.add(mangaMeta);
//         }
//       } catch (e, stacktrace) {
//         print(e);
//         print(stacktrace);
//         continue;
//       }
//     }
//     return mangaMetas;
//   }
// }
