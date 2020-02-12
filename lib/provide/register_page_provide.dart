import 'package:flutter/material.dart';

///注册页的状态
class RegisteProvide with ChangeNotifier {
  String username = '';
  String school = '';
  String realName = '';
  int role = 3;
  String nickName = '';
  String pwd = '';
  int registeType = 0;

  ///注册密码控件
  bool pwdVisable = true;

  changPwdVisable(bool status) {
    pwdVisable = status;
    notifyListeners();
  }

  void init() {
    pwdVisable = true;
    username = '';
    school = '';
    realName = '';
    role = 3;
    nickName = '';
    pwd = '';
    registeType = 0;
    notifyListeners();
  }

  changRegisteType(int type) {
    this.registeType=type;
    notifyListeners();
  }

  changUserName(String us) {
    username = us;
    notifyListeners();
  }

  void changeSchool(String school) {
    this.school = school;
    notifyListeners();
  }

  void changeRole(int role) {
    this.role = role;
    notifyListeners();
  }

  void changeRealName(String realname) {
    this.realName = realname;
    notifyListeners();
  }

  void changePwd(String pwd) {
    this.pwd = pwd;
    notifyListeners();
  }

  void changeNickName(String nickname) {
    this.nickName = nickname;
    notifyListeners();
  }
}
