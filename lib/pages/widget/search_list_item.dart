import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/fund.dart';
import 'package:no_foolish/util/dio_util.dart';

import 'fund_component.dart';

class SearchListItem extends StatefulWidget {
  late Fund _fund;
  late int _index;

  SearchListItem(
    int index,
    Fund fund, {
    Key? key,
  }) : super(key: key) {
    this._index = index;
    this._fund = fund;
  }

  @override
  State createState() {
    return SearchListState(_index, _fund);
  }
}

/// 搜索结果列表
class SearchListState extends State<SearchListItem> {
  /// 方向
  final Axis direction;

  /// 宽度
  final double width;

  late int _index;
  late Fund _fund;

  bool bind = false;

  SearchListState(
    int index,
    Fund fund, {
    Key? key,
    this.direction = Axis.vertical,
    this.width = double.infinity,
  }) {
    this._index = index;
    this._fund = fund;
    bind = fund.sort == null;
  }

  bool _upOrDown() {
    var dayGrowth = _fund.expectGrowth ?? '0';
    if (double.parse(dayGrowth) > 0) {
      return true;
    }
    return false;
  }

  _addMyFund() async {
    int code;
    await DioUtil.getInstance().addFund(_fund.fundCode!).then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Get.snackbar(BaseConstant.NONE, value.message!);
        setState(() {
          bind = true;
        });
      }
    });
  }

  _unlockMyFund() async {
    int code;
    await DioUtil.getInstance().unlockFund(_fund.fundCode!).then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        Get.snackbar(BaseConstant.NONE, value.message!);
        setState(() {
          bind = false;
        });
      } else {
        if (code < 2000) {
          Get.snackbar(BaseConstant.NONE, value.message!);
        }
        if (code == 2005) {
          Get.snackbar(BaseConstant.NONE, '登录过期了,请重新登录');
          Get.toNamed(Routes.Login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? Card(
            child: InkWell(
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                      height: 40.0,
                      child: AspectRatio(
                        aspectRatio: 2.0,
                        //左侧显示今日涨还是跌
                        child: FundComponent.leftCard(_fund.expectGrowth),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.all(
                          10.0,
                        ),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 25.0,
                                      child: Text(_fund.fundName!),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                                //根据目前的设计,关联的基金一定会有排序字段值,当sort为空可以认为没有关联,就是没有绑定该基金
                                bind
                                    ? Icon(
                                        CupertinoIcons.add,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        CupertinoIcons.clear,
                                        color: Colors.grey,
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 20.0,
                                        child: Text(_fund.fundCode!),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                                Container(
                                  height: 20.0,
                                  child:
                                      Text((_fund.netWorth ?? '').toString()),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            onTap: () {
              _fund.sort == null ? _addMyFund() : _unlockMyFund();
            },
          ))
        : Card(
            child: InkWell(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: width,
                    color: Colors.grey[200],
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 80.0,
                                  height: 15.0,
                                  color: Colors.grey[200],
                                ),
                                Container(
                                  width: 60.0,
                                  height: 10.0,
                                  margin: EdgeInsets.only(top: 8.0),
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            bind
                                ? Icon(
                                    CupertinoIcons.add,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    CupertinoIcons.clear,
                                    color: Colors.grey,
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10.0,
                              color: Colors.grey[200],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              height: 10.0,
                              color: Colors.grey[200],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              height: 10.0,
                              width: 100.0,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              _fund.sort == null ? _addMyFund() : _unlockMyFund();
            },
          ));
  }
}
