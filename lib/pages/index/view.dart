import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/pages/header/space_header.dart';
import 'package:no_foolish/pages/widget/index_list_item.dart';

import 'logic.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final IndexLogic logic = Get.put(IndexLogic());
  final EasyRefreshController _controller = EasyRefreshController();

  late SearchBar searchBar;

  _IndexPageState() {
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
    logic.searchFund(value);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<IndexLogic>(
      init: logic,
      initState: (_) {
        logic.initFunds();
      },
      builder: (_) {
        return Scaffold(
          appBar:searchBar.build(context),
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
          logic.page = 1;
          await logic.initFunds();
        },
        onLoad: () async {
          logic.page++;
          await logic.loadFunds(logic.page);
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SampleListItem(index, logic.list[index]);
              },
              childCount: logic.list.length,
            ),
          ),
        ],
        emptyWidget: logic.list.length == 0
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

  @override
  void dispose() {
    Get.delete<IndexLogic>();
    super.dispose();
  }
}
