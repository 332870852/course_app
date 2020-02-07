import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:course_app/utils/exception.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

///处理是否登录
Future notLogin() async {

}

 Future<Response> get(
    {@required String method,
    Map queryParameters,
    ProgressCallback onReceiveProgress}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  //TODO network
  if(connectivityResult==ConnectivityResult.none){
    Fluttertoast.showToast(msg: '网络不可用,请检查网络');
    throw '网络不可用,请检查网络';
  }
  Dio dio = new Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options){
     dio.interceptors.requestLock.lock();
     var token= Application.sp.get("token");
     options.headers.addAll({'token':token});
    // print("token:  ${token}");
     dio.interceptors.requestLock.unlock();
     return options;
  }));
  var url = serviceUrl + method;
  debugPrint(url);
  Map<String, dynamic> map = new Map();
  if (queryParameters != null) {
    map.addAll(queryParameters);
  }
  Response response;

  try {
    // dio.options.headers.putIfAbsent("token", ()=>"857b8e2a-91ad-4fb1-b382-8067c2720e34");//4
    dio.options.connectTimeout = 3000;
    dio.options.contentType = ContentType.json.value;
    response = await dio.get(url,
        queryParameters: map, onReceiveProgress: onReceiveProgress);
    if (response.statusCode == 200) {
      // print(response);
      return response;
    } else {
      print('code: ${response.statusCode},data:${response.data}');
    }
  } on DioError catch (e) {
    if (e.error is SocketException) {
      print(e.message);
    }
    if (e.response != null && e.response.data != null) {
      ResponseModel responseModel = ResponseModel.fromJson(e.response.data);
      throw responseModel.errors[0];
    } else {
      rethrow;
    }
  } catch (e) {
    print("get *********$e}");
    throw e;
  }
  return null;
}

 Future<Response> post(
    {@required String method,
    Map requestmap,
    data,
    contentType,int contentLength,
    Function errCallback,
    Function sendTimeOutCallBack,
    Function receiveTimeOutCallBack,
    Function connectOutCallBack,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress}) async {

  //TODO network
  var connectivityResult = await (Connectivity().checkConnectivity());
  if(connectivityResult==ConnectivityResult.none){
    Fluttertoast.showToast(msg: '网络不可用,请检查网络');
    throw '网络不可用,请检查网络';
  }
  Dio dio = new Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options){
    dio.interceptors.requestLock.lock();
    var token= Application.sp.get("token");
    options.headers.addAll({'token':token});
    // print("token:  ${token}");
    dio.interceptors.requestLock.unlock();
    return options;
  }));
  var url = serviceUrl + method;
  //var formData = FormData.fromMap(requestmap);
  print(url);
  Response response;

  try {
    //dio.options.headers.putIfAbsent("token", ()=>"857b8e2a-91ad-4fb1-b382-8067c2720e34");//
    dio.options.receiveTimeout = 30 * 1000;
    dio.options.connectTimeout = 10 * 1000;
    if (contentLength != null) {
//      dio.options.headers
//          .putIfAbsent('content-length', () => contentLength);
      print("content-length : ${contentLength}");
    }
    if (contentType != null) {
      dio.options.contentType = contentType.value;
    }
    response = await dio.post(url,
        queryParameters: requestmap,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress);
    if (response.statusCode == 200) {
      //print(response);
      return response;
    } else {
      print('code: ${response.statusCode},data:${response.data}');
    }
  } on DioError catch (e) {
    if (e.error is SocketException) {
      print("网络错误： ${e.message}");
      throw e.message;
    }
    dioErrorTip(
        e, sendTimeOutCallBack, receiveTimeOutCallBack, connectOutCallBack);
  } catch (e) {
    print("post *********$e}");
    if (e.response != null && e.response.data != null) {
      ResponseModel responseModel = ResponseModel.fromJson(e.response.data);
      throw responseModel.errors;
    } else {
      print("服务器 error:${e}");
      if (errCallback != null) {
        errCallback();
      } else {
        throw ServerErrorException(code: -1, msg: "服务器error");
      }
    }
    //throw e;
  }
  return null;
}

///网络错误回调方法
dioErrorTip(DioError e, Function sendTimeOutCallBack,
    Function receiveTimeOutCallBack, Function connectOutCallBack) {
  switch (e.type) {
    case DioErrorType.CONNECT_TIMEOUT:
      // TODO: Handle this case.
      {
        if (connectOutCallBack != null) {
          connectOutCallBack();
        } else {
          Fluttertoast.showToast(
            msg: "连接超时",
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
      break;
    case DioErrorType.SEND_TIMEOUT:
      // TODO: Handle this case.
      {
        if (sendTimeOutCallBack != null) {
          sendTimeOutCallBack();
        } else {
          Fluttertoast.showToast(
            msg: "数据发送超时",
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
      break;
    case DioErrorType.RECEIVE_TIMEOUT:
      // TODO: Handle this case.
      {
        if (receiveTimeOutCallBack != null) {
          receiveTimeOutCallBack();
        } else {
          Fluttertoast.showToast(
            msg: "数据发送超时",
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
      break;
    case DioErrorType.RESPONSE:
      // TODO: Handle this case.
      break;
    case DioErrorType.CANCEL:
      // TODO: Handle this case.
      break;
    case DioErrorType.DEFAULT:
      // TODO: Handle this case.
      break;
  }
}
