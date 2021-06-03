import 'package:flustars/flustars.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/myInfo.dart';
import 'package:no_foolish/util/dio_util.dart';

class LoginLogic extends GetxController {
  var showPassword = true.obs;

  state() => showPassword.value;

  show() => showPassword.value = true;

  hide() => showPassword.value = false;

  doLogin(String loginKey, String password) {
    DioUtil.getInstance().doLogin(loginKey, password).then((value) {
      LogUtil.v('请求结束了,判断返回值');
      if (value.code == '0000') {
        Map<String, dynamic>? data = value.data;
        if (null != data) {
          var tokenInfo = MyToken.fromJson(data["token"]);
          tokenInfo.now = DateTime.now().microsecondsSinceEpoch;
          saveToken(tokenInfo);
          var myInfo = MyInfo.fromJson(data['myInfo']);
          saveMyself(myInfo);
          Get.offNamed(Routes.Index);
        }
      }
    });
  }

  //保存登录信息
  saveMyself(MyInfo info) async {
    LogUtil.v('保存myself\n$info', tag: BaseConstant.tagLogin);
    SpUtil.putString('myself', info.toJson());
  }

  ///保存登录token信息
  saveToken(MyToken token) async {
    LogUtil.v('保存token\n$token', tag: BaseConstant.tagLogin);
    DioUtil.getInstance().setToken(token);
    SpUtil.putString('token', token.toJson());
  }

  ///页面启动时加载保存sp的登录信息，用于自动填充
  MyInfo? loadPersonPref() {
    final myselfStr = SpUtil.getString('myself');
    LogUtil.v('读取myself的数据\n$myselfStr', tag: BaseConstant.tagLogin);
    if (!ObjectUtil.isEmpty(myselfStr)) {
      final myself = JsonUtil.getObject(myselfStr, (v) => MyInfo.fromJson(v));
      return myself;
    }
    return null;
  }

  String? validateName(String? value) {
    if (ObjectUtil.isEmpty(value)) {
      return '请输入用户名';
    }
    final nameExp = RegExp(r'^[A-Za-z0-9 ]+$');
    if (!nameExp.hasMatch(value!)) {
      return '验证未过';
    }
    return null;
  }

  String? validatePassword(String? value) {
    LogUtil.v(value);
    if (value == null || value.isEmpty) {
      return '密码必填';
    }
    return null;
  }
}
