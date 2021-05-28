import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:no_foolish/common/global.dart';
import 'package:no_foolish/pages/fund/fund_detail.dart';
import 'package:no_foolish/pages/fund/search_result.dart';
import 'package:no_foolish/pages/index.dart';
import 'package:no_foolish/pages/login.dart';

import 'common/common.dart';
import 'common/router/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: BaseConstant.project,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      unknownRoute: GetPage(name: Routes.NotFound, page: () => Login()),
      initialRoute: BaseConstant.isLogin ? Routes.Index : Routes.Login,
      getPages: _initRouter(),
    );
  }

  _initRouter() {
    return [
      GetPage(
        name: Routes.Root,
        page: () => Login(),
      ),
      GetPage(
        name: '/profile/',
        page: () => Login(),
      ),
      GetPage(
        name: Routes.FundDetail,
        page: () => FundDetail(),
      ),
      GetPage(
        name: Routes.SearchResult,
        page: () => SearchResult(),
      ),
      GetPage(
        name: Routes.Index,
        page: () => Index(),
      ),
      //你可以为有参数的路由定义一个不同的页面，也可以为没有参数的路由定义一个不同的页面，但是你必须在不接收参数的路由上使用斜杠"/"，就像上面说的那样。
      GetPage(
        name: '/profile/:user',
        page: () => Login(),
      ),
      GetPage(
          name: '/third',
          page: () => Login(),
          transition: Transition.cupertino),
    ];
  }
}
