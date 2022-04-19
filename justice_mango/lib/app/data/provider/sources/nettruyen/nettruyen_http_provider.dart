import 'package:justice_mango/app/data/provider/http_provider.dart';

class NettruyenHttpProvider extends HttpProvider {
  @override
  void init() {
    dio.options.headers['Referer'] = 'https://www.nettruyenmoi.com/';
    dio.options.headers['Origin'] = 'https://www.nettruyenmoi.com';
    // dio.options.headers['User-Agent'] =
    //     'Mozilla / 5.0(Windows NT 10.0; Win64; x64; rv:87.0) Gecko / 20100101 Firefox / 87.0';
  }
}
