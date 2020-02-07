import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

class UserModelProvide with ChangeNotifier {
  UserModel user;
  String username='';//账号
  String pwd=''; //密码

  ///初始化
  void initUser(BuildContext context) {
    if (Application.sp.containsKey('user')) {
      String s = Application.sp.getString('user');
      user = UserModel.fromJson(json.decode(s));
      Provide.value<UserProvide>(context).userId =
          user.userVo.userId.toString();
      Provide.value<UserProvide>(context).role = user.userVo.role;
    }
    if(Application.sp.containsKey('pwd')) {
      pwd=Application.sp.get('pwd');
    }
    if(Application.sp.containsKey('username')) {
      username=Application.sp.get('username');
    }
  }

  /// 登录
  Future<UserModel> login(String username, String pwd, int loginType) async {
    UserModel user = await UserMethod.userLogin(username, pwd, loginType)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError, toastLength: Toast.LENGTH_LONG);
      return null;
    });
    if (user != null && user.code == 1) {
      _saveUserInfo(user,username: username,pwd: pwd).whenComplete(() {
        notifyListeners();
      });
    }
    return user;
  }

  /// 保存用户信息到 sp
  Future<void> _saveUserInfo(UserModel iuser, {String username,String pwd}) async {
    user = iuser;
    Application.sp.setString('user', json.encode(user.toJson()));
    Application.sp.setString('token', user.token);
    if (!ObjectUtil.isEmptyString(pwd)) {
      this.pwd=pwd;
      Application.sp.setString('pwd', pwd);
    }
    if (!ObjectUtil.isEmptyString(username)) {
      this.username=this.username;
      Application.sp.setString('username', username);
    }
  }

  ///删除sp的用户信息
  Future<void> deleteUserInfo() async {
    if (Application.sp.containsKey('user')) {
      Application.sp.remove('user');
    }
    if (Application.sp.containsKey('token')) {
      Application.sp.remove('token');
    }
  }

  ///退出登录
  Future<bool> logout() async {
    String username = '';
    print(user);
    if (user.loginType == 0) {
      username = user.userVo.phoneNumber;
    } else if (user.loginType == 1) {
      username = user.userVo.email;
    } else {
      username = null;
    }
    if (!ObjectUtil.isEmptyString(username)) {
      UserMethod.userlogout(username).whenComplete(() {
        ///不管退出成功与否，都要本地删除，退出
        deleteUserInfo();
      });
    }
    return true;
  }
}
