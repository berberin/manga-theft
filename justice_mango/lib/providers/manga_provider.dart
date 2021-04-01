import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:dio/dio.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';
import 'package:justice_mango/providers/http_provider.dart';

class MangaProvider {
  MangaProvider._();

  static Future<List<MangaMeta>> getLatestManga({page: 1}) async {
    var mangaMetas = <MangaMeta>[];
    var url = "http://www.nettruyen.com/tim-truyen?page=$page";
    Response response = await HttpProvider.get(url);
    var soup = Beautifulsoup(response.data.toString());
    var items = soup.find_all("div.item");

    final regId = RegExp(r'\d+');
    final regAuthor = RegExp(r'Tác giả:</label>(.+?)</p>');
    final regTags = RegExp(r'Thể loại:</label>(.+?)</p>');
    final regStatus = RegExp(r'Tình trạng:</label>(.+?)</p>');
    final regAlias = RegExp(r'Tên khác:</label>(.+?)</p>');

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
      if (!await inMangaBox(mangaMeta.id)) {
        addMangaMeta(mangaMeta);
      }
    }

    return mangaMetas;
  }

  static getMangaMeta(String mangaId) async {
    return await HiveProvider.getMangaMeta(mangaId);
  }

  static addMangaMeta(MangaMeta mangaMeta) async {
    return await HiveProvider.addToMangaBox(mangaMeta);
  }

  static Future<bool> inMangaBox(String mangaId) async {
    if (await HiveProvider.getMangaMeta(mangaId) == null) {
      return false;
    }
    return true;
  }
}
