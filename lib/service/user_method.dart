import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/user_dto.dart';
import 'package:course_app/data/user_head_image.dart';
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
  static Future<ResponseModel> updateUser(
      {@required userId, @required UserSubDto userSubDto}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());

    try {
      Response respData = await post(
        method: userPath.servicePath['updateUser'],
        requestmap: map,
        data: userSubDto.toJson(),
      );
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
      if (responseModel.code == 1) {
        print(responseModel.data);
        return responseModel;
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
            requestmap: map,//contentLength:formData.length
            data: formData,onSendProgress: onSendProgress,);
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
  static Future<UserHeadImage>uploadImage({@required String imagePath,ProgressCallback onSendProgress})async{
    File file = File(imagePath);
    if (file.existsSync()) {
      var name =
      imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.length);
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(imagePath, filename: name),
      });
      Response respData = await post(
          method: userPath.servicePath['uploadImage'],//contentLength: formData.length
          data: formData,onSendProgress: onSendProgress,);
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
}
