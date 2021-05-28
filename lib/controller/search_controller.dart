import 'package:get/get.dart';
import 'package:no_foolish/entity/fund.dart';

class SearchController extends GetxController {
  var bind = false.obs;

  bool? get() {
    return bind.value;
  }

  set(bool bind) {
    this.bind.value = bind;
  }

  ///关闭流用onClose方法，而不是dispose
  @override
  void onClose() {
    bind.close();
    super.onClose();
  }
}
