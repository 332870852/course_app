import 'dart:typed_data';

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
