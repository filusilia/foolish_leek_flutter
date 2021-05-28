import 'package:get/get.dart';
import 'package:no_foolish/entity/fund.dart';

class FavoriteController extends GetxController {
  var favorite = false.obs;

  like() => favorite.value;

  set(bool favorite) {
    this.favorite.value = favorite;
  }

  ///关闭流用onClose方法，而不是dispose
  @override
  void onClose() {
    favorite.close();
    super.onClose();
  }
}
