import 'dart:typed_data';
import 'package:course_app/config/service_url.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:course_app/utils/exception.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';

///
Future getHomePageContent() async {
  try {
    print('开始获取数据....');
    Response response;
    Dio dio = new Dio();
//    dio.options.contentType =
//        ContentType.parse("application/x-www-form-urlencoded");
    dio.options.contentType = ContentType.binary.value;
    response = await dio.get(
      'http://d-pic-image.yesky.com/' +
          '1080x-/uploadImages/2019/044/59/1113V6L3Q6TY.jpg',
    );
    if (response.statusCode == 200) {
      // return response.data;
      return '1080x-/uploadImages/2019/044/59/1113V6L3Q6TY.jpg';
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {}
}

Future<Response> get({@required String method, Map queryParameters}) async {
  var url = serviceUrl + method;
  print(url);
  Map<String, dynamic> map = new Map();
  if (queryParameters != null) {
    map.addAll(queryParameters);
  }
  Response response;
  Dio dio = new Dio();
  try {
    // dio.options.headers.putIfAbsent("token", ()=>"857b8e2a-91ad-4fb1-b382-8067c2720e34");//4
    dio.options.connectTimeout = 3000;
    dio.options.contentType = ContentType.json.value;
    response = await dio.get(
      url,
      queryParameters: map,
    );
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
    contenType,
    Function errCallback}) async {
  var url = serviceUrl + method;
  //Map<String, dynamic> map = new Map();
  var formData = FormData.fromMap(requestmap);
  //formData.fields.addAll(requestmap);
  print(formData);
//  if (requestmap!=null) {
//    map.addAll(requestmap);
//  }
  Response response;
  Dio dio = new Dio();
  try {
    //dio.options.headers.putIfAbsent("token", ()=>"857b8e2a-91ad-4fb1-b382-8067c2720e34");//
    dio.options.receiveTimeout = 30*1000;
    dio.options.connectTimeout = 5000;
    if (contenType != null) {
      dio.options.contentType = ContentType.parse(contenType).value;
    }
    response = await dio.post(url, queryParameters: requestmap, data: data,
        onReceiveProgress: (int count, int total) {
      print("count :${count},total : ${total}");
    });
    if (response.statusCode == 200) {
      print(response);
      return response;
    } else {
      print('code: ${response.statusCode},data:${response.data}');
    }
  } on DioError catch (e) {
    if (e.error is SocketException) {
      print("网络错误： ${e.message}");
      throw e.message;
    }
    if (e.response != null && e.response.data != null) {
      ResponseModel responseModel = ResponseModel.fromJson(e.response.data);
      throw responseModel.errors[0];
    } else {
      print("服务器 error:${e}");
      if (errCallback != null) {
        errCallback();
      } else {
        throw ServerErrorException(code: -1, msg: "服务器error");
      }
    }
  } catch (e) {
    print("post *********$e}");
    throw e;
  }
  return null;
}
