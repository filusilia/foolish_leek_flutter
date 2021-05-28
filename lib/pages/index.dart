import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/controller/index_controller.dart';
import 'package:no_foolish/pages/widget/index_list_item.dart';

import 'header/space_header.dart';

class Index extends StatelessWidget {
  EasyRefreshController _controller = EasyRefreshController();

  IndexController _indexController = Get.put(IndexController());

  int count = Get.find<IndexController>().count.value;

  late SearchBar searchBar;

  Index() {
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

  //回调修改正在搜索标识
  void setState(VoidCallback fn) {
    fn() as dynamic;
    _indexController.search.value = searchBar.isSearching.value;
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
    _indexController.getFund(value);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<IndexController>(
      init: _indexController,
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: _indexController.search.value
              ? searchBar.buildSearchBar(context)
              : searchBar.buildAppBar(context),
          body: buildEasyRefresh(),
        );
      },
    );
  }

  Widget buildEasyRefresh() {
    return EasyRefresh.custom(
        controller: _controller,
        header: SpaceHeader(),
        footer: BallPulseFooter(),
        onRefresh: () async {
          _indexController.page = 1;
          await _indexController.initFunds();
          LogUtil.v(count);
        },
        onLoad: () async {
          _indexController.page++;
          await _indexController.loadFunds(_indexController.page);
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return SampleListItem(index, _indexController.fundList![index]);
              },
              childCount: _indexController.count.value,
            ),
          ),
        ],
        emptyWidget: count == 0
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
            : null);
  }
}
