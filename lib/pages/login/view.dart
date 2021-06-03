import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/entity/myInfo.dart';
import 'package:no_foolish/pages/my/myself.dart';
import 'package:no_foolish/pages/widget/gradient_button_widget.dart';

import 'logic.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic logic = Get.put(LoginLogic());

  FocusNode? _password, _captcha;
  AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  var person = MyInfo();

  @override
  Widget build(BuildContext context) {
    return GetX<LoginLogic>(
      init: logic,
      initState: (_) {
        MyInfo? my = logic.loadPersonPref();
        if (null != my) {
          person = my;
        }
      },
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(BaseConstant.project),
          ),
          body: buildBody(),
        );
      },
    );
  }

  Widget buildBody() {
    const sizedBoxSpace = SizedBox(height: 24);
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            sizedBoxSpace,
            Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  initialValue: person.username,
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(CupertinoIcons.person),
                    hintText: '请输入用户名',
                    labelText: '用户名',
                  ),
                  onSaved: (value) {
                    person.username = value;
                    _password?.requestFocus();
                  },
                  validator: logic.validateName,
                ),
                sizedBoxSpace,
                TextFormField(
                  key: _passwordFieldKey,
                  obscureText: logic.state(),
                  toolbarOptions: const ToolbarOptions(
                    selectAll: true,
                    paste: true,
                  ),
                  maxLength: 15,
                  // onSaved: widget.onSaved,
                  // validator: widget.validator,
                  // onFieldSubmitted: widget.onFieldSubmitted,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '请输入密码',
                    labelText: '密码',
                    icon: Icon(CupertinoIcons.lock),
                    suffixIcon: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        logic.state() ? logic.hide() : logic.show();
                      },
                      child: Icon(
                        logic.state()
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill,
                        semanticLabel: '显示密码',
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    person.password = value;
                  },
                  validator: logic.validatePassword,
                ),
                sizedBoxSpace,
                Center(
                    child: SizedBox(
                  width: 200,
                  height: 50,
                  child: GradientBtnWidget(
                    width: double.infinity,
                    onTap: () {
                      final form = _formKey.currentState;
                      if (!form!.validate()) {
                        _autoValidateMode = AutovalidateMode.always;
                        Get.snackbar("", '请输入正确的信息');
                      } else {
                        form.save();
                        logic.doLogin(person.username!, person.password!);
                      }
                    },
                    child: BtnTextWhiteWidget(
                      text: '登录',
                    ),
                  ),
                )),
                FractionallySizedBox(),
              ],
            ),
            sizedBoxSpace,
            Text(
              'powered by ilia',
              style: Theme.of(context).textTheme.caption,
            ),
            sizedBoxSpace,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<LoginLogic>();
    super.dispose();
  }
}
