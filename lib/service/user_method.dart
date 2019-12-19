import 'package:course_app/config/service_url.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class userMethod {

  ///获取头像
  static Future<ResponseModel> getUserHeadImage({@required List userId}) async {
    Map<String, dynamic> map = new Map();
     String str= userId.toString();
     str=str.substring(1,str.length-1);
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
}
