import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 背景颜色
const Color kBgColor = Color(0xFFFEDCE0);
// 文字颜色
const Color kTextColor = Color(0xFF3D0007);
// 按钮开始颜色
const Color kBtnColorStart = Colors.lightBlueAccent;
// 按钮结束颜色
const Color kBtnColorEnd = Colors.lightBlue;
// 按钮投影颜色
const Color kBtnShadowColor = Colors.black12;
// 输入框边框颜色
const Color kInputBorderColor =  Colors.black12;

// 按钮渐变背景色
const LinearGradient kBtnLinearGradient = LinearGradient(
  colors: [
    kBtnColorStart,
    kBtnColorEnd,
  ],
);
