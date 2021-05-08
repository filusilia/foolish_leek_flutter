import 'package:flustars/flustars.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:no_foolish/common/common.dart';
import 'package:no_foolish/common/router/routes.dart';
import 'package:no_foolish/entity/myInfo.dart';
import 'package:no_foolish/util/dio_util.dart';

class Login extends StatelessWidget {
  const Login();

  @override
  Widget build(BuildContext context) {
    LogUtil.e("sp is init ${SpUtil.isInitialized()}");
    LogUtil.v(context);
    // on the framework.
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(BaseConstant.project),
      ),
      body: const LoginFormField(),
    );
  }
}

class LoginFormField extends StatefulWidget {
  const LoginFormField({Key? key}) : super(key: key);

  @override
  LoginFormFieldState createState() => LoginFormFieldState();
}

class LoginFormFieldState extends State<LoginFormField> {
  final _tag = 'login';
  var person = MyInfo();
  FocusNode? _password, _captcha;

  bool _obscureText = true; //是否是密码

  final _captchaKey = '1234';

  @override
  void initState() {
    _password = FocusNode();
    //加载配置列表文件
    _loadPersonPref();
    super.initState();
  }

  @override
  void dispose() {
    _password?.dispose();
    super.dispose();
  }

  //Incrementing counter after click
  _savePersonPref(MyInfo info) async {
    setState(() {
      LogUtil.v('保存myself\n$info', tag: _tag);
      SpUtil.putString('myself', info.toJson());
    });
  }

  ///保存登录token信息
  _saveToken(MyToken token) async {
    setState(() {
      LogUtil.v('保存token\n$token', tag: _tag);
      DioUtil.getInstance().setToken(token);
      SpUtil.putString('token', token.toJson());
    });
  }

  ///页面启动时加载保存sp的登录信息，用于自动填充
  _loadPersonPref() {
    final myselfStr = SpUtil.getString('myself');
    setState(() {
      LogUtil.v('读取myself的数据\n$myselfStr', tag: _tag);
      if (!ObjectUtil.isEmpty(myselfStr)) {
        final myself = JsonUtil.getObject(myselfStr, (v) => MyInfo.fromJson(v));
        person.username = myself!.username;
      }
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      _autoValidateMode = AutovalidateMode.always;
      showInSnackBar('请输入正确的信息');
    } else {
      form.save();
      LogUtil.d('打印person数据${JsonUtil.encodeObj(person)},准备进行http请求');
      DioUtil.getInstance()
          .doLogin(person.username, person.password)
          .then((value) {
        LogUtil.v('请求结束了,判断返回值');
        if (value.code == '0000') {
          Map<String, dynamic>? data = value.data;
          if (null != data) {
            var tokenInfo = MyToken.fromJson(data["token"]);
            tokenInfo.now = DateTime.now().microsecondsSinceEpoch;
            _saveToken(tokenInfo);
            var myInfo = MyInfo.fromJson(data['myInfo']);
            _savePersonPref(myInfo);
            showInSnackBar('${myInfo.nickname}正在登录...');
            Get.toNamed(Routes.Index);
          }
        }
      });
      LogUtil.d('网络请求结束');
    }
  }

  String? _validateName(String? value) {
    if (ObjectUtil.isEmpty(value)) {
      return '请输入用户名';
    }
    final nameExp = RegExp(r'^[A-Za-z0-9 ]+$');
    if (!nameExp.hasMatch(value!)) {
      return '验证未过';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final passwordField = _passwordFieldKey.currentState;
    if (passwordField!.value == null || passwordField.value!.isEmpty) {
      return '密码必填';
    }
    // if (passwordField.value != value) {
    //   return '密码不对';
    // }
    return null;
  }

  String? _validateCaptcha(String value) {
    if (value.isEmpty) {
      return '请输入验证码';
    }
    if (value != _captchaKey) {
      return '验证码错误!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            sizedBoxSpace,
            TextFormField(
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              initialValue: person.username,
              decoration: InputDecoration(
                filled: true,
                icon: const Icon(Icons.person),
                hintText: '请输入用户名',
                labelText: '用户名',
              ),
              onSaved: (value) {
                person.username = value;
                _password?.requestFocus();
              },
              validator: _validateName,
            ),
            sizedBoxSpace,
            TextFormField(
              key: _passwordFieldKey,
              obscureText: _obscureText,
              maxLength: 15,
              // onSaved: widget.onSaved,
              // validator: widget.validator,
              // onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                filled: true,
                hintText: '请输入密码',
                labelText: '密码',
                icon: const Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  dragStartBehavior: DragStartBehavior.down,
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    semanticLabel: '显示密码',
                  ),
                ),
              ),
              onSaved: (value) {
                person.password = value;
              },
              validator: _validatePassword,
            ),
            sizedBoxSpace,
            // TextFormField(
            //   textInputAction: TextInputAction.next,
            //   focusNode: _captcha,
            //   decoration: InputDecoration(
            //     filled: true,
            //     icon: const Icon(Icons.admin_panel_settings),
            //     hintText: '请输入验证码',
            //     labelText: '验证码',
            //   ),
            //   keyboardType: TextInputType.number,
            //   onSaved: (value) {
            //     person.captcha = value;
            //   },
            //   validator: _validateCaptcha,
            // ),//验证码暂时注释
            // sizedBoxSpace,
            Center(
                child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text('提交'),
                onPressed: _handleSubmitted,
              ),
            )),
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
}
