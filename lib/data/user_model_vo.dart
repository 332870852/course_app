import 'package:course_app/data/user_info.dart';

class UserModel {
  int code;
  int loginType;
  String msg;
  String token;
  String loginDate;
  num expire;
  UserInfoVo userVo;

  UserModel(
      {this.code,
        this.loginType,
        this.msg,
        this.token,
        this.loginDate,
        this.expire,
        this.userVo});

  @override
  String toString() {
    return 'UserModel{code: $code, loginType: $loginType, msg: $msg, token: $token, loginDate: $loginDate, expire: $expire, userVo: $userVo}';
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    loginType = json['loginType'];
    msg = json['msg'];
    token = json['token'];
    loginDate = json['loginDate'];
    expire = json['expire'];
    userVo =
    json['userVo'] != null ? new UserInfoVo.fromJson(json['userVo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['loginType'] = this.loginType;
    data['msg'] = this.msg;
    data['token'] = this.token;
    data['loginDate'] = this.loginDate;
    data['expire'] = this.expire;
    if (this.userVo != null) {
      data['userVo'] = this.userVo.toJson();
    }
    return data;
  }
}