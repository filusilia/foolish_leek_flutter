import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/common/global.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/myInfo.dart';
import 'package:no_foolish/entity/resultResponse.dart';
import 'package:no_foolish/util/custom_tool.dart';

/// 请求方法.
class Method {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

/// 单例 DioUtil.
/// debug模式下可以打印请求日志. DioUtil.openDebug().
/// dio详细使用请查看dio官网(https://github.com/flutterchina/dio).
class DioUtil {
  static final DioUtil _singleton = DioUtil._init();
  static final _dio = Dio(); // with default Options

  DioUtil._init() {
    _dio.options.baseUrl = Global.isRelease ? Global.prodUrl : Global.devUrl;
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 3000;
    var logDebug = LogInterceptor();
    logDebug.requestBody = true;
    logDebug.responseBody = true;
    _dio.interceptors.add(logDebug);
  }

  static DioUtil getInstance() {
    return _singleton;
  }

  factory DioUtil() {
    return _singleton;
  }

  void setToken(MyToken token) {
    Map<String, dynamic> _headers = new Map();
    _headers[token.tokenName!] = 'Bearer ' + token.tokenValue!;
    _dio.options.headers.addAll(_headers);
  }

  void setCookie(String cookie) {
    Map<String, dynamic> _headers = new Map();
    _headers["Cookie"] = cookie;
    _dio.options.headers.addAll(_headers);
  }

  /// 登录
  Future<ResultResponse> doLogin(String? loginKey, String? password) async {
    var response = await _dio
        .post('user/login', data: {'loginKey': loginKey, 'password': password});
    return checkReturn(response.data);
  }

  /// 更新登录
  Future<ResultResponse> refresh() async {
    var response = await _dio.get('user/updateLogin');
    return checkReturn(response.data);
  }

  /// 判断是否登录
  Future<ResultResponse> isLogin() async {
    var response = await _dio.get('user/isLogin');
    return checkReturn(response.data);
  }

  /// 分页获取基金
  Future<ResultResponse> getFunds(int page, {int? pageSize = 10}) async {
    var response = await _dio.get('fund/listFund',
        queryParameters: {'page': page, 'pageSize': pageSize});
    return checkReturn(response.data);
  }

  ///实时获取基金
  Future<ResultResponse> getRealTime(String code) async {
    var response = await _dio
        .get('fund/realTimeFundByCode', queryParameters: {'fundCode': code});
    return checkReturn(response.data);
  }

  ///查询基金
  Future<ResultResponse> searchFund(
      String? code, String? pinyin, String? name, int page,
      {int? pageSize = 20}) async {
    var response = await _dio.get('fund/searchFund', queryParameters: {
      'fundCode': code,
      'pinyin': pinyin,
      'fundName': name,
      'page': page,
      'pageSize': pageSize
    });
    return checkReturn(response.data);
  }

  ///添加我的基金
  Future<ResultResponse> addFund(String code) async {
    var response = await _dio.post('fund/addMyFund', data: {'fundCode': code});
    return checkReturn(response.data);
  }

  ///解绑基金
  Future<ResultResponse> unlockFund(String code) async {
    var response =
        await _dio.post('fund/unlockMyFund', data: {'fundCode': code});
    return checkReturn(response.data);
  }

  ///收藏/取消收藏基金
  ///favorite:1-收藏,0-取消
  Future<ResultResponse> favoriteFund(String code, String favorite) async {
    var response = await _dio.post('fund/favoriteFund',
        data: {'fundCode': code, 'favorite': favorite});
    return checkReturn(response.data);
  }

  ResultResponse checkReturn(dynamic response) {
    ResultResponse result = ResultResponse.fromJson(response);
    if (CustomTool.isNumeric(result.code)) {
      int code = int.parse(result.code!);
      if (code != 0) {
        if (code < 2000) {
          Get.snackbar(BaseConstant.FAILED, result.message!);
        }
        if (code == 2005) {
          Get.snackbar("Failed", '登录过期了,请重新登录');
          Get.toNamed(Routes.Login);
        }
      }
      return result;
    }
    Get.snackbar(BaseConstant.FAILED, '网络请求数据异常');
    throw new Exception('网络请求返回数据发生错误.');
  }
}
