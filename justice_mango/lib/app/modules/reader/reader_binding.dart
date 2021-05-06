import 'package:get/get.dart';
import 'package:justice_mango/app/modules/reader/reader_controller.dart';

class ReaderBinding extends Bindings {
  @override
  void dependencies() {
    // issue get: ^4.1.4
    // lazyPut bị lỗi khi gọi 2 route trùng nhau liên tiếp (mất container)
    // https://github.com/jonataslaw/getx/issues/945#issuecomment-796395938
    Get.create(() => ReaderController());
  }
}
