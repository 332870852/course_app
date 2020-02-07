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
  static Future<UserModel> userLogin(String username,String password,int loginType)async{
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('pwd', () => password);
    map.putIfAbsent('loginType', () => loginType);
    Response respData = await post(
        method: userPath.servicePath['userLongin'], requestmap: map);
    UserModel userModel = UserModel.fromJson(respData.data);
    if (userModel.code == 1) {
      return userModel;
    } else {
      throw userModel.msg;
    }
  }

  ///刷新登录
  static Future<UserModel> refreshLogin(String username) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    Response respData = await post(method: userPath.servicePath['refreshLogin'], requestmap: map)
        .catchError((e) {
    });
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if(responseModel.code==1){
      Map map=responseModel.data;
      UserModel userModel=UserModel.fromJson(map);
      return userModel;
    }else{
      throw responseModel.errors[0];
    }

  }

  ///退出登录
  static Future<bool> userlogout(String username)async{
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    Response respData = await post(method: userPath.servicePath['userlogout'], requestmap: map)
        .catchError((e) {
    });
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if(responseModel.code==1){
      return responseModel.data;
    }else{
      throw responseModel.errors[0];
    }
  }


  ///获取头像
  static Future<ResponseModel> getUserHeadImage({@required List userId}) async {
    Map<String, dynamic> map = new Map();
    String str = userId.toString();
    str = str.substring(1, str.length - 1);
    //print(str);
    map.putIfAbsent('userId', () => str);
    Response respData = await get(
        method: userPath.servicePath['getUserHeadImage'], queryParameters: map);
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if (responseModel.code == 1) {
      //print(responseModel.data);
      return responseModel;
    } else {
      throw responseModel.errors[0];
    }
  }

  ///获取用户资料
  static Future<ResponseModel> getUserInfo({@required userId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());
    Response respData = await get(
        method: userPath.servicePath['getUserInfo'], queryParameters: map);
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if (responseModel.code == 1) {
      //print(responseModel.data);
      return responseModel;
    } else {
      throw responseModel.errors[0];
    }
  }

  ///修改个人信息
  static Future<dynamic> updateUser(
      {@required userId, @required UserSubDto userSubDto}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());
    try {
      Response respData = await post(
          method: userPath.servicePath['updateUser'],
          requestmap: map,
          data: userSubDto.toJson(),
          connectOutCallBack: () {
            Fluttertoast.showToast(
              msg: '更改失败，服务器繁忙请稍后再试',
              gravity: ToastGravity.BOTTOM,
            );
          });
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
      if (responseModel.code == 1) {
        print(responseModel.data);
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    } catch (e) {
      print("系统错误");
    }
    return false;
  }

  ///上传头像图片
  static Future<UserHeadImage> uploadFaceFile(String userId,
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
        Response respData = await post(
          method: userPath.servicePath['uploadFaceFile'],
          requestmap: map, //contentLength:formData.length
          data: formData, onSendProgress: onSendProgress,
        );
        ResponseModel responseModel = ResponseModel.fromJson(respData.data);
        if (responseModel.code == 1) {
          print(responseModel.data);
          return UserHeadImage.fromJson(responseModel.data);
        } else {
          throw responseModel.errors[0];
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
  static Future<UserHeadImage> uploadImage(
      {@required String imagePath, ProgressCallback onSendProgress}) async {
    File file = File(imagePath);
    if (file.existsSync()) {
      var name =
          imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.length);
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(imagePath, filename: name),
      });
      Response respData = await post(
        method: userPath.servicePath['uploadImage'],
        //contentLength: formData.length
        data: formData,
        onSendProgress: onSendProgress,
      );
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
      if (responseModel.code == 1) {
        print(responseModel.data);
        return UserHeadImage.fromJson(responseModel.data);
      } else {
        throw responseModel.errors.asMap();
      }
    }
    return null;
  }

  ///获取公告
  static Future<List<AnnouncementVo>> getAnnouncementPage(
      {@required String userId, @required String courseId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('courseId', () => courseId);
    try {
      Response respData = await post(
        method: userPath.servicePath['getAnnouncementPage'],
        requestmap: map,
      );
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
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
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///批量获取个人资料
  static Future<List<UserInfoVo>> getEveryUserInfo(List<String> userId) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    try {
      Response respData = await post(
        method: userPath.servicePath['getEveryUserInfo'],
        requestmap: map,
      );
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
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
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///查看公告评论
  static Future<List<ReplyList>> getReplyListPage(
      String announceId, String userId,
      {int pageNo=1, int pageSize=10}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('announceId', () => announceId);
    map.putIfAbsent('pageNo', () => pageNo);
    map.putIfAbsent('pageSize', () => pageSize);
    try {
      Response respData = await post(
        method: userPath.servicePath['getReplyListPage'],
        requestmap: map,
      );
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
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
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

}
