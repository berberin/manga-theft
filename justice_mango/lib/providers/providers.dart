import 'hive_provider.dart';
import 'http_provider.dart';

class Providers {
  static init() async {
    await HiveProvider.init();
    await HttpProvider.init();
  }
}
