import 'dart:convert';

import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/announcement_vo.dart';
import 'package:course_app/data/comment_vo.dart';
import 'package:course_app/data/user_dto.dart';
import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:course_app/utils/exception.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserMethod {
  ///登录
  static Future<UserModel> userLogin(BuildContext context, String username,
      String password, int loginType) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('pwd', () => password);
    map.putIfAbsent('loginType', () => loginType);
    ResponseModel responseModel = await post(context,
        method: userPath.servicePath['userLongin'], requestmap: map);
    print(responseModel.data);
    if (responseModel.code == 1) {
      Map map = responseModel.data;
      UserModel userModel = UserModel.fromJson(map);
      if (responseModel != null && userModel.code == 1) {
        return userModel;
      } else {
        throw userModel.msg;
      }
    } else {
      throw responseModel.errors[0];
    }
  }

  ///刷新登录
  static Future<UserModel> refreshLogin(
      BuildContext context, String username) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    ResponseModel responseModel = await post(context,
            method: userPath.servicePath['refreshLogin'], requestmap: map)
        .catchError((e) {});
    if (responseModel != null) {
      if (responseModel.code == 1) {
        Map map = responseModel.data;
        UserModel userModel = UserModel.fromJson(map);
        return userModel;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///退出登录
  static Future<bool> userlogout(BuildContext context, String username) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    ResponseModel responseModel = await post(context,
            method: userPath.servicePath['userlogout'], requestmap: map)
        .catchError((e) {});
    if(responseModel!=null){
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///获取头像
  static Future<ResponseModel> getUserHeadImage(BuildContext context,
      {@required List userId}) async {
    Map<String, dynamic> map = new Map();
    String str = userId.toString();
    str = str.substring(1, str.length - 1);
    //print(str);
    map.putIfAbsent('userId', () => str);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserHeadImage'], queryParameters: map);
    if(responseModel!=null){
      if (responseModel.code == 1) {
        //print(responseModel.data);
        return responseModel;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///获取用户资料
  static Future<UserInfoVo> getUserInfo(BuildContext context,
      {@required userId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserInfo'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        //print(responseModel.data);
        UserInfoVo userInfoVo=UserInfoVo.fromJson(responseModel.data);
        return userInfoVo;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///修改个人信息
  static Future<bool> updateUser(BuildContext context,
      {@required userId, @required UserSubDto userSubDto}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());

    ResponseModel responseModel = await post(context,
        method: userPath.servicePath['updateUser'],
        requestmap: map,
        data: userSubDto.toJson(), connectOutCallBack: () {
      Fluttertoast.showToast(
        msg: '更改失败，服务器繁忙请稍后再试',
        gravity: ToastGravity.BOTTOM,
      );
    });
    if (responseModel != null) {
      if (responseModel.code == 1) {
        print(responseModel.data);
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    }
    return false;
  }

  ///上传头像图片
  static Future<UserHeadImage> uploadFaceFile(
      BuildContext context, String userId,
      {@required imagePath, ProgressCallback onSendProgress}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());
    File file = File(imagePath);
    if (file.existsSync()) {
      // map.putIfAbsent('file', () => file.readAsBytesSync());
      var name =
          imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.length);
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(imagePath, filename: name),
      });
      print(file);

      try {
        ResponseModel responseModel = await post(
          context,
          method: userPath.servicePath['uploadFaceFile'],
          requestmap: map, //contentLength:formData.length
          data: formData, onSendProgress: onSendProgress,
        );
        if (responseModel != null) {
          if (responseModel.code == 1) {
            print(responseModel.data);
            return UserHeadImage.fromJson(responseModel.data);
          } else {
            throw responseModel.errors[0];
          }
        }
      } on ServerErrorException catch (e) {
        Fluttertoast.showToast(
          msg: '更改失败，服务器繁忙请稍后再试',
          gravity: ToastGravity.BOTTOM,
        );
        print(e.msg);
      } catch (e) {
        print("系统错误");
      }
    }
    return null;
  }

  ///上传图片
  static Future<UserHeadImage> uploadImage(BuildContext context,
      {@required String imagePath, ProgressCallback onSendProgress}) async {
    File file = File(imagePath);
    if (file.existsSync()) {
      var name =
          imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.length);
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(imagePath, filename: name),
      });
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['uploadImage'],
        //contentLength: formData.length
        data: formData,
        onSendProgress: onSendProgress,
      );
      if (responseModel != null) {
        if (responseModel.code == 1) {
          print(responseModel.data);
          return UserHeadImage.fromJson(responseModel.data);
        } else {
          throw responseModel.errors.asMap();
        }
      }
    }
    return null;
  }

  ///获取公告
  static Future<List<AnnouncementVo>> getAnnouncementPage(BuildContext context,
      {@required String userId, @required String courseId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('courseId', () => courseId);
    try {
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['getAnnouncementPage'],
        requestmap: map,
      );
      if (responseModel != null) {
        if (responseModel.code == 1) {
          print(responseModel.data);
          List<AnnouncementVo> annoList = [];
          List<dynamic> list = responseModel.data;
          list.forEach((item) {
            annoList.add(AnnouncementVo.fromJson(item));
          });
          return annoList;
        } else {
          throw responseModel.errors[0];
        }
      }
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///批量获取个人资料
  static Future<List<UserInfoVo>> getEveryUserInfo(
      BuildContext context, List<String> userId) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    try {
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['getEveryUserInfo'],
        requestmap: map,
      );
      if (responseModel != null) {
        if (responseModel.code == 1) {
          print(responseModel.data);
          List<UserInfoVo> userList = [];
          List<dynamic> list = responseModel.data;
          list.forEach((item) {
            userList.add(UserInfoVo.fromJson(item));
          });
          return userList;
        } else {
          throw responseModel.errors[0];
        }
      }
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///查看公告评论
  static Future<List<ReplyList>> getReplyListPage(
      BuildContext context, String announceId, String userId,
      {int pageNo = 1, int pageSize = 10}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('announceId', () => announceId);
    map.putIfAbsent('pageNo', () => pageNo);
    map.putIfAbsent('pageSize', () => pageSize);
    try {
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['getReplyListPage'],
        requestmap: map,
      );
      if (responseModel != null) {
        if (responseModel.code == 1) {
          print(responseModel.data);
          List<ReplyList> replyList = [];
          List<dynamic> list = responseModel.data;
          list.forEach((item) {
            replyList.add(ReplyList.fromJson(item));
          });
          return replyList;
        } else {
          throw responseModel.errors[0];
        }
      }
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///获取用户的二维码
  static Future<String> getUserQRcode(BuildContext context,
      {bool update}) async {
    print("update: ${update}");
    Map<String, dynamic> map = Map();
    map.putIfAbsent('update', () => update);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserQRcode'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///判断账号是否被注册过
  static Future<bool> exitsUserName(
      BuildContext context, String username, int type) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('type', () => type);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['exitsUserName'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///用户注册
  static Future<bool> registerUser(BuildContext context,
      {@required String username,
      @required String pwd,
      @required int role,
      @required String school,
      @required String realName,
      @required String nickname,
      int type = 0}) async {
    assert(type > -1 && type < 2);
    UserSubDto userSubDto = UserSubDto(
        schoolName: school, realName: realName, nickname: nickname, role: role);
    UserDto userDto = new UserDto(password: pwd, userSubDto: userSubDto);
    if (type == 0) {
      userDto.phoneNumber = username;
    } else {
      userDto.email = username;
    }
    print(userDto);
    Map<String, dynamic> map = Map();
    map.putIfAbsent('type', () => type);
    ResponseModel responseModel = await post(
      context,
      method: userPath.servicePath['registerUser'],
      data: userDto.toJson(),
      requestmap: map,
    );
    //print("rrrrrrrrrrrr:${responseModel}");
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }


  ///查找用户
  static Future<UserInfoVo> getUserFriendById(
      BuildContext context, String username,{String freindId,int findType=1}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('freindId', () => freindId);
    map.putIfAbsent('findType', () => findType);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserFriendById'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        UserInfoVo userInfoVo=UserInfoVo.fromJson(responseModel.data);
        return userInfoVo;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }
}
