import 'package:manga_theft/app/data/provider/http_provider.dart';

class NettruyenHttpProvider extends HttpProvider {
  final baseUrl = 'www.nettruyen.com';

  @override
  void init() {
    dio.options.headers['Referer'] = 'https://$baseUrl/';
    dio.options.headers['Origin'] = 'https://$baseUrl';
    // dio.options.headers['User-Agent'] =
    //     'Mozilla / 5.0(Windows NT 10.0; Win64; x64; rv:87.0) Gecko / 20100101 Firefox / 87.0';
  }
}
