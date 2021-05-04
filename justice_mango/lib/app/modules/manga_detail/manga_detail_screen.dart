import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_controller.dart';

class MangaDetailScreen extends GetWidget<MangaDetailController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(controller.mangaMeta.title),
      ),
    );
  }
}
