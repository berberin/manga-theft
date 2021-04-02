class ChaptersInfo {
  int chapterId;
  String name;
  String url;

  ChaptersInfo({this.chapterId, this.name, this.url});

  factory ChaptersInfo.fromJson(Map<String, dynamic> json) {
    return ChaptersInfo(
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
