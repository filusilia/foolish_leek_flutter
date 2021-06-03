import 'package:flutter/material.dart';
import 'package:no_foolish/pages/widget/theme/app_colors.dart';
import 'package:no_foolish/pages/widget/theme/app_size.dart';
import 'package:no_foolish/pages/widget/theme/app_style.dart';

/// 渐变按钮组件
class GradientBtnWidget extends StatelessWidget {
  const GradientBtnWidget({
    Key? key,
    required this.width,
    required this.child,
    required this.onTap,
  }) : super(key: key);
  final double width;
  final Widget child;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 48,
        decoration: BoxDecoration(
          gradient: kBtnLinearGradient,
          boxShadow: kBtnShadow,
          borderRadius: BorderRadius.circular(kBtnRadius),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

/// 白色按钮文字
class BtnTextWhiteWidget extends StatelessWidget {
  const BtnTextWhiteWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kBtnTextStyle.copyWith(
        color: Colors.white,
      ),
    );
  }
}
