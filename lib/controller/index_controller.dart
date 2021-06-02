import 'package:flustars/flustars.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/fund.dart';
import 'package:no_foolish/util/custom_tool.dart';
import 'package:no_foolish/util/dio_util.dart';

class IndexController extends GetxController {
  //给StatelessWidget的首页APPbar添加一个search状态用于build更改搜索框;
  final search = false.obs;

  //列表总数
  final total = 0.obs;

  //当前基金列表
  List<Fund>? fundList;

  //页码
  int page = 0;

  //每页数量
  int pageSize = 10;

  //当前加载数量
  final count = 0.obs;

  pushList(List<Fund>? list) {}

  ///搜索基金
  searchFund(String value) {
    List<String> search = value.split(' ');
    Fund? fund = Fund.fromParams();
    for (var temp in search) {
      if (CustomTool.isNumeric(temp)) {
        fund.fundCode = temp;
      } else if (temp.isAlphabetOnly) {
        fund.fundFullPinyin = temp;
      } else {
        fund.fundName = temp;
      }
    }
    int code;
    DioUtil.getInstance()
        .searchFund(fund.fundCode, fund.fundFullPinyin, fund.fundName, 1)
        .then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Map<String, dynamic> data = value.data;
        var _data = data['data'];
        if (_data.isNotEmpty) {
          List<Fund>? result =
              JsonUtil.getObjectList(_data, (v) => Fund.fromJson(v));
          Get.toNamed(Routes.SearchResult,
              arguments: {'list': result, 'query': fund});
        } else {
          Get.snackbar("", '没有找到您想要查询的基金');
        }
      }
    });
  }

  ///初始化基金列表
  initFunds() async {
    int code;
    await DioUtil.getInstance().getFunds(1, pageSize: pageSize).then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Map<String, dynamic> data = value.data;
        total.value = data['total'];
        var _data = data['data'];
        Get.snackbar("", '加载成功');
        if (_data != null) {
          fundList = JsonUtil.getObjectList(_data, (v) => Fund.fromJson(v));
        }
        if (null != fundList && fundList!.length > 0) {
          count.value = fundList!.length;
          LogUtil.v('count  $count');
        }
      }
    });
  }

  ///加载指定页码的基金列表
  loadFunds(int page) async {
    int code;
    await DioUtil.getInstance()
        .getFunds(page, pageSize: pageSize)
        .then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Map<String, dynamic> data = value.data;
        total.value = data['total'];
        var _data = data['data'];
        if (null != fundList && fundList!.length > 0) {
          if (_data != null) {
            var tempList =
                JsonUtil.getObjectList(_data, (v) => Fund.fromJson(v));
            if (null != tempList && tempList.length > 0) {
              fundList!.addAll(tempList.reversed);
              Get.snackbar(BaseConstant.NONE, '加载成功');
            } else {
              page = page - 1;
              Get.snackbar(BaseConstant.NONE, '没有更多数据啦');
            }
          }
          count.value = fundList!.length;
        } else {
          page = page - 1;
          Get.snackbar(BaseConstant.NONE, '没有更多数据啦');
        }
      }
    });
  }
}
