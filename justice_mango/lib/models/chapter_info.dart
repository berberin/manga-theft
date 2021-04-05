class ChapterInfo {
  int chapterId;
  String name;
  String url;

  ChapterInfo({this.chapterId, this.name, this.url});

  factory ChapterInfo.fromJson(Map<String, dynamic> json) {
    return ChapterInfo(
      chapterId: json['chapterId'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapterId'] = this.chapterId;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
