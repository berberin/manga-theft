enum BaseStatus { initial, loading, success, failed }

enum FavoriteCardStyle {
  shortMangaCard("short_manga_card"),
  shortMangaBar("short_manga_bar");

  final String value;

  const FavoriteCardStyle(this.value);
}

const String favoriteCardStyleKey = "favorite_card_style";
