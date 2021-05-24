import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/controller/fund_controller.dart';
import 'package:no_foolish/entity/fund.dart';
import 'package:no_foolish/util/dio_util.dart';

/// 搜索结果列表
class SearchListItem extends StatelessWidget {
  final FundController c = Get.put(FundController());

  /// 方向
  final Axis direction;

  /// 宽度
  final double width;

  late int _index;
  late Fund _fund;

  SearchListItem(
    int index,
    Fund fund, {
    Key? key,
    this.direction = Axis.vertical,
    this.width = double.infinity,
  }) : super(key: key) {
    this._index = index;
    this._fund = fund;
  }

  _getRealTime(String fundCode) async {
    int code;
    await DioUtil.getInstance().getRealTime(fundCode).then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        var nowFund = JsonUtil.getObject(value.data, (v) => Fund.fromJson(v));

        LogUtil.v(nowFund, tag: 'realTime');
        Get.toNamed(Routes.FundDetail, arguments: nowFund);
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

  bool _upOrDown() {
    var dayGrowth = _fund.expectGrowth ?? '0';
    if (double.parse(dayGrowth) > 0) {
      return true;
    }
    return false;
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
                        child: _upOrDown()
                            ? Row(
                                children: <Widget>[
                                  Icon(
                                    CupertinoIcons.chevron_up,
                                    color: Colors.red[600],
                                  ),
                                  Container(
                                    color: Colors.red[400],
                                    child: Text(_fund.expectGrowth ?? '0',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ],
                              )
                            : Row(
                                children: <Widget>[
                                  Icon(
                                    CupertinoIcons.chevron_down,
                                    color: Colors.green[600],
                                  ),
                                  Container(
                                    color: Colors.green[400],
                                    child: Text(_fund.expectGrowth ?? '0',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ],
                              )),
                  ),
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
                                _fund.favorite == '1'
                                    ? Icon(
                                        CupertinoIcons.star_fill,
                                        color: Colors.yellow,
                                      )
                                    : Icon(
                                        CupertinoIcons.star,
                                        color: Colors.grey,
                                      )
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
              _getRealTime(_fund.fundCode!);
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
                            Icon(
                              Icons.star,
                              color: Colors.grey[200],
                            )
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
              _getRealTime(_fund.fundCode!);
            },
          ));
  }
}
