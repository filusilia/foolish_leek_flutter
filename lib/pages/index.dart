import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/pages/widget/sample_list_item.dart';
import 'package:no_foolish/util/dio_util.dart';

import 'header/space_header.dart';

///主页
class Index extends StatelessWidget {
  const Index();

  @override
  Widget build(BuildContext context) {
    LogUtil.e("sp is init ${SpUtil.isInitialized()}");
    // on the framework.
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(BaseConstant.project),
      ),
      body: const IndexField(),
    );
  }
}

class IndexField extends StatefulWidget {
  const IndexField({Key? key}) : super(key: key);

  @override
  IndexFieldState createState() => IndexFieldState();
}

class IndexFieldState extends State<IndexField> {
  // 总数
  int _count = 20;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      header: SpaceHeader(),
      onRefresh: () async {
        LogUtil.v('ok onRefresh');
        await Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {});
          }
        });
      },
      onLoad: () async {
        LogUtil.v('ok onLoad');
        int code;
        await DioUtil.getInstance().getFunds(1, pageSize: _count).then((value) {
          code = int.parse(value.code!);
          if (code == 0) {
            if (mounted) {
              setState(() {
                LogUtil.v(value, tag: 'funds');
              });
            }
          }
          if (code < 2000) {
            showInSnackBar(value.message!);
          }
          if (value.code == "2005") {
            showInSnackBar('登录过期了,请重新登录');
            Get.toNamed(Routes.Index);
          }
        });
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return SampleListItem();
            },
            childCount: _count,
          ),
        ),
      ],
    );
  }
}
