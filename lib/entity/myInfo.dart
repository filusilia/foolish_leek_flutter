import 'dart:convert';

///token
class MyToken {
  int? tokenTimeout;
  bool? isLogin;
  String? loginDevice;
  String? loginId;
  String? loginKey;
  String? tokenName;
  String? tokenValue;
  int? now;

  MyToken.fromParams(
      {this.tokenTimeout,
      this.isLogin,
      this.loginDevice,
      this.loginId,
      this.loginKey,
      this.tokenName,
      this.tokenValue,
      this.now});

  MyToken.fromJson(jsonRes) {
    tokenTimeout = jsonRes['tokenTimeout'];
    isLogin = jsonRes['isLogin'];
    loginDevice = jsonRes['loginDevice'];
    loginId = jsonRes['loginId'];
    loginKey = jsonRes['loginKey'];
    tokenName = jsonRes['tokenName'];
    tokenValue = jsonRes['tokenValue'];
    now = jsonRes['now'];
  }

  @override
  String toString() {
    return '{"tokenTimeout": $tokenTimeout, '
        '"isLogin": $isLogin, '
        '"now": $now, '
        '"loginDevice": ${loginDevice != null ? '${json.encode(loginDevice)}' : 'null'}, '
        '"loginId": ${loginId != null ? '${json.encode(loginId)}' : 'null'}, '
        '"loginKey": ${loginKey != null ? '${json.encode(loginKey)}' : 'null'}, '
        '"tokenName": ${tokenName != null ? '${json.encode(tokenName)}' : 'null'}, '
        '"tokenValue": ${tokenValue != null ? '${json.encode(tokenValue)}' : 'null'}}';
  }

  String toJson() => this.toString();
}

///我的
class MyInfo {
  MyInfo();
  int? createBy;
  int? userCode;
  String? nickname;
  String? sex;
  String? username;
  String? password;

  MyInfo.fromParams(
      {this.createBy, this.userCode, this.nickname, this.sex, this.username});

  MyInfo.fromJson(jsonRes) {
    createBy = jsonRes['createBy'];
    userCode = jsonRes['userCode'];
    nickname = jsonRes['nickname'];
    sex = jsonRes['sex'];
    username = jsonRes['username'];
    password = jsonRes['password'];
  }

  @override
  String toString() {
    return '{"createBy": $createBy, '
        '"userCode": $userCode, '
        '"nickname": ${nickname != null ? '${json.encode(nickname)}' : 'null'}, '
        '"sex": ${sex != null ? '${json.encode(sex)}' : 'null'}, '
        '"username": ${username != null ? '${json.encode(username)}' : 'null'}},'
        '"password": ${password != null ? '${json.encode(password)}' : 'null'}}';
  }

  String toJson() => this.toString();
}
