import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/fund.dart';
import 'package:no_foolish/pages/header/space_header.dart';
import 'package:no_foolish/pages/widget/sample_list_item.dart';
import 'package:no_foolish/util/dio_util.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  State createState() {
    final Map<String, dynamic> data = Get.arguments;

    return SearchResultState(data['data'] ?? null);
  }
}

class SearchResultState extends State<SearchResult> {
  //当前数量
  int _count = 0;

  //页码
  int _page = 1;

  //每页数量
  int _pageSize = 10;
  List<Fund>? _list;

  SearchResultState(List<Fund>? list) {
    _list = list;
    _count = list?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('查询结果')), body: buildEasyRefresh());
  }

  //加载指定页码的基金列表
  _loadSearchFunds(int page) async {
    int code;
    await DioUtil.getInstance()
        .getFunds(page, pageSize: _pageSize)
        .then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Map<String, dynamic> data = value.data;
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

  Widget buildEasyRefresh() {
    return EasyRefresh.custom(
      header: SpaceHeader(),
      footer: BallPulseFooter(),
      onRefresh: () async {
        LogUtil.v('不需要初始化');
      },
      onLoad: () async {
        LogUtil.v('ok onLoad');

        await _loadSearchFunds(_page);
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
                    "查询结果空 ",
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
