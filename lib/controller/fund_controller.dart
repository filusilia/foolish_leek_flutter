import 'package:get/get.dart';
import 'package:no_foolish/entity/fund.dart';

class FundController extends GetxController {
  var _fund = Fund
      .parse('')
      .obs;

  Fund? get() {
    return _fund.value;
  }

  set(Fund fund) {
    _fund.value = fund;
  }

  ///关闭流用onClose方法，而不是dispose
  @override
  void onClose() {
    _fund.close();
    super.onClose();
  }
}