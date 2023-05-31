import 'package:flutter/cupertino.dart';

class LayoutConstants {
  LayoutConstants._();

  static const BoxDecoration backcardMangaBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xffffffff),
        Color(0xa0ffffff),
      ],
    ),
  );
  static const BoxDecoration upwardMangaBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Color(0xffffffff),
        Color(0xa0ffffff),
      ],
    ),
  );
}
