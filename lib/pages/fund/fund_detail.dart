import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/fund.dart';
import 'package:no_foolish/pages/widget/list_item.dart';
import 'package:no_foolish/util/dio_util.dart';

class FundDetail extends StatelessWidget {
  final Fund _fund = Get.arguments;
  String favorite = '';

  _favoriteFund() async {
    favorite = _fund.favorite!;
    int code;
    await DioUtil.getInstance()
        .favoriteFund(_fund.fundCode!, _fund.favorite!)
        .then((value) {
      code = int.parse(value.code!);
      if (code == 0) {
        if (favorite == '1') {
          Get.snackbar("Success", '取消收藏成功');
          _fund.favorite = '0';
        } else {
          Get.snackbar("Success", '收藏成功');
          _fund.favorite = '1';
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
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text(_fund.fundName!), actions: [
          IconButton(
              icon: _fund.favorite == '1'
                  ? Icon(CupertinoIcons.star_fill,
                      color: Colors.yellow, semanticLabel: "收藏")
                  : Icon(CupertinoIcons.star,
                      color: Colors.grey, semanticLabel: "收藏"),
              onPressed: () {
                _favoriteFund();
              })
        ]),
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            EasyRefresh.custom(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    // 顶部栏
                    new Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 220.0,
                          color: Colors.white,
                        ),
                        ClipPath(
                          clipper: new TopBarClipper(
                              MediaQuery.of(context).size.width, 200.0),
                          child: new SizedBox(
                            width: double.infinity,
                            height: 200.0,
                            child: new Container(
                              width: double.infinity,
                              height: 240.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        // 名字
                        Container(
                          margin: new EdgeInsets.only(top: 40.0),
                          child: new Center(
                            child: new Text(
                              _fund.fundName!,
                              style: new TextStyle(
                                  fontSize: 30.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 内容
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                          color: Colors.blue,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                ListItem(
                                  icon: Icon(
                                    CupertinoIcons.money_dollar_circle,
                                    color: Colors.white,
                                  ),
                                  title: _fund.fundFullPinyin!,
                                  titleColor: Colors.white,
                                  describe: _fund.fundCode!,
                                  describeColor: Colors.white,
                                  onPressed: () {},
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 25.0,
                                          child: Text('基金类型',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 2,
                                      child: DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                    Text(_fund.fundType!,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 25.0,
                                          child: Text('基金经理',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 2,
                                      child: DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                    Text(_fund.manager!,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 25.0,
                                          child: Text('当前基金单位净值',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 2,
                                      child: DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                    Text(_fund.netWorth.toString(),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 25.0,
                                          child: Text('当前基金累计净值',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 2,
                                      child: DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                    Text(_fund.totalWorth.toString(),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 25.0,
                                          child: Text('单位净值日涨幅',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 2,
                                      child: DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                    Text(_fund.dayGrowth.toString(),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 25.0,
                                          child: Text('单位净值月涨幅',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 2,
                                      child: DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                    Text(_fund.lastMonthGrowth.toString(),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ));
  }
}

// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopBarClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height / 2);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
