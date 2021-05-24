import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/fund.dart';
import 'package:no_foolish/pages/widget/sample_list_item.dart';
import 'package:no_foolish/util/custom_tool.dart';
import 'package:no_foolish/util/dio_util.dart';

import 'header/space_header.dart';

///主页
class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  IndexFieldState createState() => IndexFieldState();
}

class IndexFieldState extends State<Index> {
  late SearchBar searchBar;
  late EasyRefreshController _controller;

  //当前数量
  int _count = 0;

  //总数
  int _total = 0;

  //页码
  int _page = 1;

  //每页数量
  int _pageSize = 10;
  List<Fund>? _list;

  IndexFieldState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        hintText: '请输入想查询的基金',
        onCleared: () {
          print("Search bar has been cleared");
        },
        onClosed: () {
          print("Search bar has been closed");
        });
  }

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _controller.callLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(title: Text(BaseConstant.project), actions: [
      IconButton(
          icon: Icon(CupertinoIcons.search, semanticLabel: "搜索"),
          onPressed: () {
            searchBar.beginSearch(context);
          })
    ]);
  }

  void onSubmitted(String value) {
    LogUtil.v('submit $value');
    _getFund(value);
  }

  //搜索基金
  _getFund(String value) {
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
        LogUtil.v(_data);
        if (_data.isNotEmpty) {
          var result = JsonUtil.getObjectList(data, (v) => Fund.fromJson(v));
          LogUtil.v(result);
          Get.toNamed(Routes.SearchResult, arguments: data);
        } else {
          Get.snackbar("", '没有找到您想要查询的基金');
        }
      }
    });
  }

  //初始化基金列表
  _initFunds() async {
    int code;
    await DioUtil.getInstance().getFunds(1, pageSize: _pageSize).then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Map<String, dynamic> data = value.data;
        _total = data['total'];
        var _data = data['data'];
        Get.snackbar("", '加载成功');
        if (_data != null) {
          _list = JsonUtil.getObjectList(_data, (v) => Fund.fromJson(v));
        }
        if (mounted && null != _list && _list!.length > 0) {
          setState(() {
            _count = _list!.length;
          });
        }
      } else {
        if (code < 2000) {
          Get.snackbar("Failed", value.message!);
        }
        if (code == 2005) {
          Get.snackbar("Failed", '登录过期了,请重新登录');
          Get.toNamed(Routes.Login);
        }
      }
    });
  }

  //加载指定页码的基金列表
  _loadFunds(int page) async {
    int code;
    await DioUtil.getInstance()
        .getFunds(page, pageSize: _pageSize)
        .then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Map<String, dynamic> data = value.data;
        _total = data['total'];
        var _data = data['data'];
        if (mounted && null != _list && _list!.length > 0) {
          if (_data != null) {
            var tempList =
                JsonUtil.getObjectList(_data, (v) => Fund.fromJson(v));
            if (null != tempList && tempList.length > 0) {
              _list!.addAll(tempList.reversed);
            } else {
              _page = page - 1;
              Get.snackbar("", '没有更多数据啦');
            }
          }
          Get.snackbar("", '加载成功');
          setState(() {
            _count = _list!.length;
          });
        } else {
          _page = page - 1;
          Get.snackbar("", '没有更多数据啦');
        }
      } else {
        if (code < 2000) {
          Get.snackbar("Failed", value.message!);
        }
        if (code == 2005) {
          Get.snackbar("Failed", '登录过期了,请重新登录');
          Get.toNamed(Routes.Login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: buildEasyRefresh(),
    );
  }

  Widget buildEasyRefresh() {
    return EasyRefresh.custom(
      controller: _controller,
      header: SpaceHeader(),
      footer: BallPulseFooter(),
      onRefresh: () async {
        LogUtil.v('ok onRefresh');
        _page = 1;
        _count = 0;
        await _initFunds();
      },
      onLoad: () async {
        LogUtil.v('ok onLoad');
        _page++;
        await _loadFunds(_page);
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return SampleListItem(index, _list![index]);
            },
            childCount: _count,
          ),
        ),
      ],
      emptyWidget: _count == 0
          ? Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset('assets/images/empty.png'),
                  ),
                  Text(
                    "没有基金",
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                  ),
                  Expanded(
                    child: SizedBox(),
                    flex: 3,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
