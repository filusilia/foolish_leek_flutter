import 'package:dio/dio.dart';
import 'package:no_foolish/entity/myInfo.dart';
import 'package:no_foolish/entity/resultResponse.dart';

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
  final baseUrl = 'http://localhost:8080/foolish/';
  static final DioUtil _singleton = DioUtil._init();
  static final _dio = Dio(); // with default Options

  DioUtil._init() {
    _dio.options.baseUrl = baseUrl;
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
    return ResultResponse.fromJson(response.data);
  }

  /// 更新登录
  Future<ResultResponse> refresh() async {
    var response = await _dio.get('user/updateLogin');
    return ResultResponse.fromJson(response.data);
  }

  /// 判断是否登录
  Future<ResultResponse> isLogin() async {
    var response = await _dio.get('user/isLogin');
    return ResultResponse.fromJson(response.data);
  }

  /// 分页获取基金
  Future<ResultResponse> getFunds(int page, {int? pageSize = 10}) async {
    var response = await _dio
        .post('fund/listFund', data: {'page': page, 'pageSize': pageSize});
    return ResultResponse.fromJson(response.data);
  }

  ///实时获取基金
  Future<ResultResponse> getRealTime(String code) async {
    var response =
        await _dio.post('fund/realTimeFundByCode', data: {'fundCode': code});
    return ResultResponse.fromJson(response.data);
  }

  ///查询基金
  Future<ResultResponse> searchFund(
      String? code, String? pinyin, String? name, int page,
      {int? pageSize = 20}) async {
    var response = await _dio.post('fund/searchFund',
        data: {'fundCode': code, 'pinyin': pinyin, 'fundName': name});
    return ResultResponse.fromJson(response.data);
  }

  ///添加我的基金
  Future<ResultResponse> addFund(String code) async {
    var response = await _dio.post('fund/addMyFund', data: {'fundCode': code});
    return ResultResponse.fromJson(response.data);
  }

  ///收藏/取消收藏基金
  ///favorite:1-收藏,0-取消
  Future<ResultResponse> favoriteFund(String code, String favorite) async {
    var response = await _dio.post('fund/favoriteFund',
        data: {'fundCode': code, 'favorite': favorite});
    return ResultResponse.fromJson(response.data);
  }
}
