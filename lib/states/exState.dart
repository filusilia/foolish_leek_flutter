import 'package:get/get.dart';
import 'package:no_foolish/entity/myInfo.dart';

class UserController extends GetxController {
  var user = MyInfo();

  var isOnline = false.obs;

  bool isLogin = false;

  set online(bool online) => isLogin = online;

  bool get online => isLogin;
}
