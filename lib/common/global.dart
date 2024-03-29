import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:no_foolish/entity/myInfo.dart';
import 'package:no_foolish/models/profile.dart';
import 'package:no_foolish/util/dio_util.dart';

import 'common.dart';

// 提供四套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.orange,
  Colors.green,
  Colors.red,
];

///全局配置
class Global {
  static Profile profile = Profile();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool isRelease = false;

  ///开发请求地址
  static String devUrl = 'http://localhost:8080/foolish/';

  ///release地址
  static String prodUrl = 'http://xxx:8080/foolish/';

  //初始化全局信息
  static Future init() async {
    LogUtil.init(isDebug: true);
    await SpUtil.getInstance();
    checkToken();
    isLogin();
  }

  static checkToken() {
    //初始化查询token数据
    final tokenObj = SpUtil.getString('token');
    if (!ObjectUtil.isEmpty(tokenObj)) {
      LogUtil.v('读取完毕tokenObj，现在打印值:\n$tokenObj', tag: BaseConstant.tagInit);
      final token = JsonUtil.getObject(tokenObj, (v) => MyToken.fromJson(v));
      if (null != token) {
        var before = DateTime.fromMicrosecondsSinceEpoch(token.now!);
        if (DateTime.now().difference(before).inSeconds < token.tokenTimeout!) {
          DioUtil.getInstance().setToken(token);
          LogUtil.v('没问题奥 已经登录了，直接进入列表吧.', tag: BaseConstant.tagInit);
          DioUtil.getInstance().refresh().then((value) {
            int code;
            code = int.parse(value.code!);
            if (code == 0) {
              var tokenInfo = MyToken.fromJson(value.data);
              tokenInfo.now = DateTime.now().microsecondsSinceEpoch;
              SpUtil.putString('token', token.toJson());
            }
          });
          BaseConstant.isLogin = true;
        } else {
          LogUtil.v('超时了,token留着也没用了,直接删除.', tag: BaseConstant.tagInit);
          SpUtil.remove('token');
        }
      }
    }
  }

  static MyInfo? isLogin() {
    //初始化查询user数据
    final myselfStr = SpUtil.getString('myself');
    if (!ObjectUtil.isEmpty(myselfStr)) {
      LogUtil.v('读取完毕myselfStr，现在打印值:\n$myselfStr', tag: BaseConstant.tagInit);
      final myself = JsonUtil.getObject(myselfStr, (v) => MyInfo.fromJson(v));
      return myself;
    }
    return null;
  }
}
