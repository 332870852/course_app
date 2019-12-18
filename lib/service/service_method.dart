import 'dart:typed_data';
import 'package:course_app/config/service_url.dart';
import 'package:course_app/utils/ResponseModel.dart';
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
    dio.options.contentType=ContentType.binary;
    response = await dio.get('http://d-pic-image.yesky.com/'+'1080x-/uploadImages/2019/044/59/1113V6L3Q6TY.jpg', );
    if (response.statusCode == 200) {
     // return response.data;
      return '1080x-/uploadImages/2019/044/59/1113V6L3Q6TY.jpg';
    }else{
      throw Exception('后端接口出现异常');
    }
  } catch (e) {}
}



Future<Response> get({@required String method, Map queryParameters}) async {
  var url = serviceUrl+method;
  Map<String, dynamic> map = new Map();
  if (queryParameters!=null) {
    map.addAll(queryParameters);
  }
  Response response;
  Dio dio = new Dio();
  try {
   // dio.options.headers.putIfAbsent("token", ()=>"857b8e2a-91ad-4fb1-b382-8067c2720e34");//
    dio.options.connectTimeout=3000;
    response =  await dio.get(url,queryParameters: queryParameters);
    if (response.statusCode == 200) {
      //print(response);
      return response;
    } else {
      print('code: ${response.statusCode},data:${response.data}');
    }
  } on DioError catch(e){
    if(e.error is SocketException){
      print(e.message);
    }
    if(e.response!=null&&e.response.data!=null){
      ResponseModel responseModel=ResponseModel.fromJson(e.response.data);
     throw responseModel.errors[0];
    }else{
      rethrow ;
    }
  }catch (e) {
    print("get *********$e}");
    throw e;
  }
  return null;
}


Future<Response> post({@required String method, Map requestmap}) async {
  var url = serviceUrl+method;
  //Map<String, dynamic> map = new Map();
  FormData formData=FormData();
  formData.addAll(requestmap);
  print(formData);
//  if (requestmap!=null) {
//    map.addAll(requestmap);
//  }
  Response response;
  Dio dio = new Dio();
  try {//b9995e80-314a-4d5f-896c-1999ffa19639
    //dio.options.headers.putIfAbsent("token", ()=>"857b8e2a-91ad-4fb1-b382-8067c2720e34");//
    response =  await dio.post(url,queryParameters: formData,);
    if (response.statusCode == 200) {
      print(response);
      return response;
    } else {
      print('code: ${response.statusCode},data:${response.data}');
    }
  } on DioError catch(e){
    if(e.error is SocketException){
      print(e.message);
      return null;
    }
    if(e.response.data!=null){
      ResponseModel responseModel=ResponseModel.fromJson(e.response.data);
      throw responseModel.errors[0];
    }else{
      rethrow ;
    }
  }catch (e) {
    print("post *********$e}");
    throw e;
  }
  return null;
}
