import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:flutter/material.dart';

class UserProvide with ChangeNotifier {
  List<UserHeadImage> userImageList = [];
  UserInfoVo tacherInfo;

  ///获取课堂头像
  Future<List<UserHeadImage>> getUserHeadImage(List ids) async {
    ResponseModel responseModel;
    if (ids != null && ids.isEmpty == false && userImageList.length < 1) {
      print("wwwwwwwwww${ids}");
      responseModel = await userMethod.getUserHeadImage(userId: ids);
      List<dynamic> list = responseModel.data;
      userImageList = list
          .map((image) {
            return UserHeadImage.fromJson(image);
          })
          .toList()
          .cast();
      return userImageList;
    }
    return userImageList;
  }

  ///获取老师信息
  Future<UserInfoVo> getTeacherInfo({@required teacherId}) async {
    ResponseModel responseModel;
    if (teacherId.toString().isNotEmpty && tacherInfo == null) {
      print("ttttttttt${teacherId}");
      responseModel = await userMethod.getUserInfo(userId: teacherId);
      if (responseModel.data != null) {
        tacherInfo = UserInfoVo.fromJson(responseModel.data);
      }
    }
    return tacherInfo;
  }
}
