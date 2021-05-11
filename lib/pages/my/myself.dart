import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:no_foolish/pages/widget/list_item.dart';

class Myself extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<Myself> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "我的",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          brightness: Brightness.dark,
        ),
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
                              'KnoYo',
                              style: new TextStyle(
                                  fontSize: 30.0, color: Colors.white),
                            ),
                          ),
                        ),
                        // 图标
                        Container(
                          margin: new EdgeInsets.only(top: 100.0),
                          child: new Center(
                              child: new Container(
                            width: 100.0,
                            height: 100.0,
                            child: new PreferredSize(
                              child: new Container(
                                child: new ClipOval(
                                  child: new Container(
                                    color: Colors.white,
                                    child: new Image.asset(
                                        'assets/image/head_knoyo.jpg'),
                                  ),
                                ),
                              ),
                              preferredSize: new Size(80.0, 80.0),
                            ),
                          )),
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
                                    Icons.supervised_user_circle,
                                    color: Colors.white,
                                  ),
                                  title: "QQ",
                                  titleColor: Colors.white,
                                  describe: '100000',
                                  describeColor: Colors.white,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                          color: Colors.green,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                ListItem(
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  title: "姓名",
                                  titleColor: Colors.white,
                                  describe: 'KnoYo',
                                  describeColor: Colors.white,
                                ),
                                ListItem(
                                  icon: EmptyIcon(),
                                  title: "年龄",
                                  titleColor: Colors.white,
                                  describe: "",
                                  describeColor: Colors.white,
                                ),
                              ],
                            ),
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                          color: Colors.teal,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                ListItem(
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  title: "电话",
                                  titleColor: Colors.white,
                                  describe: '18888888888',
                                  describeColor: Colors.white,
                                ),
                                ListItem(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  title: "邮件",
                                  titleColor: Colors.white,
                                  describe: 'xuelongqy@foxmail.com',
                                  describeColor: Colors.white,
                                  onPressed: () {},
                                )
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
