import 'package:get/get.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/pages/login.dart';
import 'package:no_foolish/pages/my/myself.dart';


class AppPages {
  static const INITIAL = Routes.Root;

  static final List<GetPage> routes = [
    // 白名单
    GetPage(
      name: Routes.Login,
      page: () => Login(),
    ),

    // 我的，需要认证
    GetPage(
      name: Routes.Myself,
      page: () => Myself(),
      // middlewares: [
      //   RouteAuthMiddleware(priority: 1),
      // ],
    )
  ];
}
