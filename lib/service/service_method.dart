import 'dart:typed_data';
import 'package:common_utils/common_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/pages/login_page.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/utils/QRcodeScanUtil.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:course_app/utils/exception.dart';
import 'package:course_app/utils/navigatorUtil.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

///处理未登录或身份失效请求
Future notLogin(context) async {
  var b = await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertionDialog(
          title: '用户身份过期或已失效',
          content: '请返回登录页面重新校验身份',
          onOk: () {
            Navigator.pop(context, 1);
          },
          onCancel: () {
            Navigator.pop(context, 0);
          },
          isLoding: false,
        );
      });
  if (b == 1) {
    await Provide.value<UserModelProvide>(context).deleteUserInfo();
    //Provide.value<WebSocketProvide>(context).close();
    String username = Provide.value<UserModelProvide>(context).username;
    String pwd = Provide.value<UserModelProvide>(context).pwd;
    NavigatorUtil.goLoginPage(context, username: username, pwd: pwd);

    ///返回登录页
  }
}

///url 白名单，不用校验身份
final List<String> whileUrl = [
  serviceUrl + userPath.servicePath['userLongin'],
  //userPath.servicePath['refreshLogin'],
  serviceUrl + userPath.servicePath['userlogout'],
];


Future<ResponseModel> getSys(
  BuildContext context,
  String url, {
  Map queryParameters,
  ProgressCallback onReceiveProgress,
  Function sendTimeOutCallBack,
  Function receiveTimeOutCallBack,
  Function connectOutCallBack,
}) async {
  Dio dio = new Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
    dio.interceptors.requestLock.lock();
    var token = Application.sp.get("token");
    options.headers.addAll({'token': token});
    dio.interceptors.requestLock.unlock();
    return options;
  }));
  dio.options.connectTimeout = 7 * 1000;
  dio.options.contentType = ContentType.json.value;
  Response response = await dio.get(url,
       onReceiveProgress: onReceiveProgress);
  try {
    if (response.statusCode == 200) {
      // print(response);
      ResponseModel responseModel = ResponseModel.fromJson(response.data);
      if (ObjectUtil.isNotEmpty(responseModel.errors) &&
          responseModel.errors[0].code == 400) {
        ///未登录
        await notLogin(context);
        throw responseModel.errors[0].message;
      }
      return responseModel;
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
    print("get *********$e}");
    throw e;
  }
  return null;
}

Future<ResponseModel> get(
  BuildContext context, {
  @required String method,
  Map queryParameters,
  ProgressCallback onReceiveProgress,
  Function sendTimeOutCallBack,
  Function receiveTimeOutCallBack,
  Function connectOutCallBack,
}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  //TODO network
  if (connectivityResult == ConnectivityResult.none) {
    Fluttertoast.showToast(msg: '网络不可用,请检查网络');
    throw '网络不可用,请检查网络';
  }
  Dio dio = new Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
    dio.interceptors.requestLock.lock();
    var token = Application.sp.get("token");
    options.headers.addAll({'token': token});
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
    dio.options.connectTimeout = 7 * 1000;
    dio.options.contentType = ContentType.json.value;
    response = await dio.get(url,
        queryParameters: map, onReceiveProgress: onReceiveProgress);
    if (response.statusCode == 200) {
      // print(response);
      ResponseModel responseModel = ResponseModel.fromJson(response.data);
      if (ObjectUtil.isNotEmpty(responseModel.errors) &&
          responseModel.errors[0].code == 400) {
        ///未登录
        await notLogin(context);
        throw responseModel.errors[0].message;
      }
      return responseModel;
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
    print("get *********$e}");
    throw e;
  }
  return null;
}

Future<ResponseModel> post(BuildContext context,
    {@required String method,
    Map requestmap,
    data,
    contentType,
    int contentLength,
    Function errCallback,
    Function sendTimeOutCallBack,
    Function receiveTimeOutCallBack,
    Function connectOutCallBack,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress}) async {
  //TODO network
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    Fluttertoast.showToast(msg: '网络不可用,请检查网络');
    throw '网络不可用,请检查网络';
  }
  Dio dio = new Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
    dio.interceptors.requestLock.lock();
    var token = Application.sp.get("token");
    options.headers.addAll({'token': token});
    // print("token:  ${token}");
    dio.interceptors.requestLock.unlock();
    return options;
  }));
  var url = serviceUrl + method;
  print(url);
  Response response;
  ResponseModel responseModel;
  try {
    dio.options.receiveTimeout = 30 * 1000;
    dio.options.connectTimeout = 7 * 1000;
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
    // print('rrrrrrrrrrrrrr :${response}');
    if (response.statusCode == 200) {
      // print(response);
      responseModel = ResponseModel.fromJson(response.data);
      if (ObjectUtil.isNotEmpty(responseModel.errors) &&
          responseModel.errors[0].code == 400) {
        ///未登录
        await notLogin(context);
        throw responseModel.errors[0].message;
      }
      return responseModel;
    } else {
      print('code: ${response.statusCode},data:${response.data}');
    }
  } on DioError catch (e) {
    print("网络错误： ${e.message}");
//    if (e.error is SocketException) {
//      print("网络错误： ${e.message}");
//      throw e.message;
//    }
    dioErrorTip(
        e, sendTimeOutCallBack, receiveTimeOutCallBack, connectOutCallBack);
    //throw e.message;
    // return null;
  } catch (e) {
    print("post *********$e}");
    if (errCallback != null) {
      errCallback();
    } else {
      throw ServerErrorException(code: -1, msg: "服务器error");
    }
    throw e;
  }
  //
  if (!whileUrl.contains(url)) {
    await notLogin(context);
    return new ResponseModel(0, '', '', '', null, [Error(400, '用户身份过期或已失效')]);
  }
  return null;
}

///网络错误回调方法
dioErrorTip(DioError e, Function sendTimeOutCallBack,
    Function receiveTimeOutCallBack, Function connectOutCallBack) {
  debugPrint(e.type.toString());
  switch (e.type) {
    case DioErrorType.CONNECT_TIMEOUT:
      // TODO: Handle this case.
      {
        if (connectOutCallBack != null) {
          print('connectOutCallBack');
          connectOutCallBack();
          return null;
        } else {
          Fluttertoast.showToast(
            msg: "连接超时",
            gravity: ToastGravity.BOTTOM,
          );
          throw e.message;
        }
      }
      break;
    case DioErrorType.SEND_TIMEOUT:
      // TODO: Handle this case.
      {
        if (sendTimeOutCallBack != null) {
          sendTimeOutCallBack();
          return null;
        } else {
          Fluttertoast.showToast(
            msg: "数据发送超时",
            gravity: ToastGravity.BOTTOM,
          );
          throw e.message;
        }
      }
      break;
    case DioErrorType.RECEIVE_TIMEOUT:
      // TODO: Handle this case.
      {
        if (receiveTimeOutCallBack != null) {
          receiveTimeOutCallBack();
          return null;
        } else {
          Fluttertoast.showToast(
            msg: "数据发送超时",
            gravity: ToastGravity.BOTTOM,
          );
          throw e.message;
        }
      }
      break;
    case DioErrorType.RESPONSE:
      // TODO: Handle this case.
      {}
      break;
    case DioErrorType.CANCEL:
      {}
      // TODO: Handle this case.
      break;
    case DioErrorType.DEFAULT:
      {}
      // TODO: Handle this case.
      break;
  }
}
