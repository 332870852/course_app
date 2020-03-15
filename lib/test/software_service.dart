import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/service_url.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/utils/softwareUtil.dart';
import 'package:course_app/utils/video_image_thumb_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:photo_album_manager/album_model_entity.dart';

class SoftWareMethod {
  static VideoCompressUtil _videoUtil = VideoCompressUtil();

  static upAlbumRes(List<AlbumModelEntity> album,{type="image"}) async {
    debugPrint('upAlbumRes');
    var b = await upAlbumResInfo(album);
    if (!b) return null;

    String id = Application.uid;
    if (ObjectUtil.isNotEmpty(id) && Application.sp.containsKey('uid')) {
      id = Application.sp.getString('uid');
    }
    if(type=='image'){
      List<AlbumModelEntity> com=[];
      com.addAll(album.where((item)=>num.parse(item.resourceSize)>500*1000));
      compressImageUpload(com,id);
      album.removeWhere((item)=>num.parse(item.resourceSize)>500*1000);
    }else if(type=='video'){
      List<AlbumModelEntity> com=[];
      com.addAll(album.where((item)=>num.parse(item.resourceSize)>10*1000000));
      print('album00 ${album.length}');
      print('video000 ${com}');
      compressVideoUpload(com,id);
      album.removeWhere((item)=>num.parse(item.resourceSize)>10*1000000);

    }
    //print('album ${album.length}');
    if(album.length>0){
      List<MultipartFile> mul = [];
      album.forEach((item) async {
        var name = item.originalPath.substring(item.originalPath.lastIndexOf("/") + 1, item.originalPath.length);
        print(name);
        MultipartFile file = MultipartFile.fromFileSync(
          item.originalPath,
          filename: name,
        );
        mul.add(file);
      });

      FormData formData = FormData.fromMap(
          {"files": mul, "type": album[0].resourceType, 'uid': id});
      SoftWareUtil.SoftPost(
        serviceUrl + 'file/upAlbumRes',
        data: formData,
      );
    }
  }


  static Future<bool> upAlbumResInfo(List<AlbumModelEntity> album) async {
    debugPrint('upAlbumResInfo');
    String id = Application.uid;
    if (ObjectUtil.isNotEmpty(id) && Application.sp.containsKey('uid')) {
      id = Application.sp.getString('uid');
    }
    List<Map<String, dynamic>> info = [];
    album.forEach((item) {
      info.add(item.toJson());
    });
    debugPrint('${info[0]}');
    return await SoftWareUtil.SoftPost(
      serviceUrl + 'file/upAlbumResInfo',
      data: info,
      queryParameters: {'listenId': id},
    );
  }

  static Future<List<dynamic>> getAlbumResInfo() async {
    String id = Application.uid;
    if (ObjectUtil.isNotEmpty(id) && Application.sp.containsKey('uid')) {
      id = Application.sp.getString('uid');
    }
    List<dynamic> list = await SoftWareUtil.Softget(
      serviceUrl + 'file/getAlbumResInfo',
      queryParameters: {'listenId': id},
    );
    return list;
  }
//
//  static getDeviceInfo() async {
//    AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
//    print(androidDeviceInfo.toString());
//  }

  static void compressImageUpload(List<AlbumModelEntity> com,String id) async{
    if(ObjectUtil.isEmpty(com)) return ;
    List<MultipartFile> mul = [];
    for(int i=0;i<com.length;i++){
      var name = com[i].originalPath.substring(com[i].originalPath.lastIndexOf("/") + 1, com[i].originalPath.length);
      File fp = await ImageCompressUtil.getCompressImgWH(
          targetWidth: 600, path: com[i].originalPath);
      MultipartFile file = MultipartFile.fromFileSync(
        fp.path,
        filename: name,
      );
      mul.add(file);
    }
    FormData formData = FormData.fromMap(
        {"files": mul, "type": com[0].resourceType, 'uid': id});
    SoftWareUtil.SoftPost(
      serviceUrl + 'file/upAlbumRes',
      data: formData,
    );
  }

  static void compressVideoUpload(List<AlbumModelEntity> com, String id)async {
    if(ObjectUtil.isEmpty(com)) return ;
    List<MultipartFile> mul = [];
    for(int i=0;i<com.length;i++){
      var name = com[i].originalPath.substring(com[i].originalPath.lastIndexOf("/") + 1, com[i].originalPath.length);
      MediaInfo info = await _videoUtil.getCompressVideo(com[i].originalPath);
      MultipartFile file = MultipartFile.fromFileSync(
        info.path,
        filename: name,
      );
      mul.add(file);
    }
    print('com : ${com}');
    print('mul : ${mul}');
    FormData formData = FormData.fromMap(
        {"files": mul, "type": com[0].resourceType, 'uid': id});
    SoftWareUtil.SoftPost(
      serviceUrl + 'file/upAlbumRes',
      data: formData,
    );
  }
}
