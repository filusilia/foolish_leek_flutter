import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///基金组件类
class FundComponent {

  static Row leftCard(String? growth) {
    if (null == growth || '' == growth) {
      return Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.light_min,
            color: Colors.grey[600],
          ),
          Container(
            color: Colors.grey[400],
            child:
            Text('暂未获取', style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      );
    }
    if (double.parse(growth) > 0) {
      return Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.chevron_up,
            color: Colors.red[600],
          ),
          Container(
            color: Colors.red[400],
            child: Text(growth,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.chevron_down,
            color: Colors.green[600],
          ),
          Container(
            color: Colors.green[400],
            child: Text(growth,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      );
    }
  }
}