import 'dart:convert';
import 'package:course_app/data/topic_comement_dto.dart';
import 'package:course_app/data/topic_dto.dart';
import 'package:course_app/data/topic_vo.dart';
import 'package:mime_type/mime_type.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/announcement_vo.dart';
import 'package:course_app/data/chat/friend_model.dart';
import 'package:course_app/data/comment_vo.dart';
import 'package:course_app/data/user_dto.dart';
import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:course_app/utils/base64_util.dart';
import 'package:course_app/utils/exception.dart';
import 'package:course_app/utils/video_image_thumb_util.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/src/media_type.dart';

class UserMethod {
  ///登录
  static Future<UserModel> userLogin(BuildContext context, String username,
      String password, int loginType) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('pwd', () => password);
    map.putIfAbsent('loginType', () => loginType);
    ResponseModel responseModel = await post(context,
        method: userPath.servicePath['userLongin'], requestmap: map);
    print(responseModel.data);
    if (responseModel.code == 1) {
      Map map = responseModel.data;
      UserModel userModel = UserModel.fromJson(map);
      if (responseModel != null && userModel.code == 1) {
        return userModel;
      } else {
        throw userModel.msg;
      }
    } else {
      throw responseModel.errors[0];
    }
  }

  ///刷新登录
  static Future<UserModel> refreshLogin(
      BuildContext context, String username) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    ResponseModel responseModel = await post(context,
            method: userPath.servicePath['refreshLogin'], requestmap: map)
        .catchError((e) {});
    if (responseModel != null) {
      if (responseModel.code == 1) {
        Map map = responseModel.data;
        UserModel userModel = UserModel.fromJson(map);
        return userModel;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///退出登录
  static Future<bool> userlogout(BuildContext context, String username) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    ResponseModel responseModel = await post(context,
            method: userPath.servicePath['userlogout'], requestmap: map)
        .catchError((e) {});
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///获取头像
  static Future<ResponseModel> getUserHeadImage(BuildContext context,
      {@required List userId}) async {
    Map<String, dynamic> map = new Map();
    String str = userId.toString();
    str = str.substring(1, str.length - 1);
    //print(str);
    map.putIfAbsent('userId', () => str);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserHeadImage'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        //print(responseModel.data);
        return responseModel;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///获取用户资料
  static Future<UserInfoVo> getUserInfo(BuildContext context,
      {@required userId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserInfo'], queryParameters: map);
    print(responseModel.data);
    if (responseModel != null) {
      if (responseModel.code == 1 && responseModel.data != null) {
        //print(responseModel.data);
        UserInfoVo userInfoVo = UserInfoVo.fromJson(responseModel.data);
        return userInfoVo;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///修改个人信息
  static Future<bool> updateUser(BuildContext context,
      {@required userId, @required UserSubDto userSubDto}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId.toString());

    ResponseModel responseModel = await post(context,
        method: userPath.servicePath['updateUser'],
        requestmap: map,
        data: userSubDto.toJson(), connectOutCallBack: () {
      Fluttertoast.showToast(
        msg: '更改失败，服务器繁忙请稍后再试',
        gravity: ToastGravity.BOTTOM,
      );
    });
    if (responseModel != null) {
      if (responseModel.code == 1) {
        print(responseModel.data);
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    }
    return false;
  }

  ///上传头像图片
  static Future<UserHeadImage> uploadFaceFile(
      BuildContext context, String userId,
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
        ResponseModel responseModel = await post(
          context,
          method: userPath.servicePath['uploadFaceFile'],
          requestmap: map, //contentLength:formData.length
          data: formData, onSendProgress: onSendProgress,
        );
        if (responseModel != null) {
          if (responseModel.code == 1) {
            print(responseModel.data);
            return UserHeadImage.fromJson(responseModel.data);
          } else {
            throw responseModel.errors[0];
          }
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
  static Future<UserHeadImage> uploadImage(BuildContext context,
      {@required String imagePath, ProgressCallback onSendProgress}) async {
    File file = File(imagePath);
    if (file.existsSync()) {
      var name =
          imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.length);
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(imagePath, filename: name),
      });
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['uploadImage'],
        //contentLength: formData.length
        data: formData,
        onSendProgress: onSendProgress,
      );
      if (responseModel != null) {
        if (responseModel.code == 1) {
          print(responseModel.data);
          return UserHeadImage.fromJson(responseModel.data);
        } else {
          throw responseModel.errors.asMap();
        }
      }
    }
    return null;
  }

  ///获取公告
  static Future<List<AnnouncementVo>> getAnnouncementPage(BuildContext context,
      {@required String userId, @required String courseId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('courseId', () => courseId);
    try {
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['getAnnouncementPage'],
        requestmap: map,
      );
      if (responseModel != null) {
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
      }
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///批量获取个人资料
  static Future<List<UserInfoVo>> getEveryUserInfo(
      BuildContext context, List<String> userId) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    try {
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['getEveryUserInfo'],
        requestmap: map,
      );
      if (responseModel != null) {
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
      }
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///查看公告评论
  static Future<List<ReplyList>> getReplyListPage(
      BuildContext context, String announceId, String userId,
      {int pageNo = 1, int pageSize = 10}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('announceId', () => announceId);
    map.putIfAbsent('pageNo', () => pageNo);
    map.putIfAbsent('pageSize', () => pageSize);
    try {
      ResponseModel responseModel = await post(
        context,
        method: userPath.servicePath['getReplyListPage'],
        requestmap: map,
      );
      if (responseModel != null) {
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
      }
    } catch (e) {
      print("系统错误: ${e}");
    }
    return null;
  }

  ///获取用户的二维码
  static Future<String> getUserQRcode(BuildContext context,
      {bool update}) async {
    print("update: ${update}");
    Map<String, dynamic> map = Map();
    map.putIfAbsent('update', () => update);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserQRcode'], queryParameters: map);
    // print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///判断账号是否被注册过
  static Future<bool> exitsUserName(
      BuildContext context, String username, int type) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('type', () => type);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['exitsUserName'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///用户注册
  static Future<bool> registerUser(BuildContext context,
      {@required String username,
      @required String pwd,
      @required int role,
      @required String school,
      @required String realName,
      @required String nickname,
      int type = 0}) async {
    assert(type > -1 && type < 2);
    UserSubDto userSubDto = UserSubDto(
        schoolName: school, realName: realName, nickname: nickname, role: role);
    UserDto userDto = new UserDto(password: pwd, userSubDto: userSubDto);
    if (type == 0) {
      userDto.phoneNumber = username;
    } else {
      userDto.email = username;
    }
    print(userDto);
    Map<String, dynamic> map = Map();
    map.putIfAbsent('type', () => type);
    ResponseModel responseModel = await post(
      context,
      method: userPath.servicePath['registerUser'],
      data: userDto.toJson(),
      requestmap: map,
    );
    //print("rrrrrrrrrrrr:${responseModel}");
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///查找用户
  static Future<UserInfoVo> getUserFriend(BuildContext context, String username,
      {String freindId, int findType = 1}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('freindId', () => freindId);
    map.putIfAbsent('findType', () => findType);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getUserFriend'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        UserInfoVo userInfoVo = UserInfoVo.fromJson(responseModel.data);
        return userInfoVo;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///modify password
  static Future<bool> userPwdChange(BuildContext context, String username,
      String oldPwd, String newPwd) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('username', () => username);
    map.putIfAbsent('oldPwd', () => oldPwd);
    map.putIfAbsent('newPwd', () => newPwd);
    ResponseModel responseModel = await post(context,
        method: userPath.servicePath['userPwdChange'], requestmap: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///批量获取用户信息
  static Future<List<UserInfoVo>> getStudentInfo(
      BuildContext context, List<String> studentId) async {
    debugPrint('getStudentInfo');
    List<UserInfoVo> result = [];
    if (studentId.isEmpty) {
      return result;
    }
    Map<String, dynamic> map = new Map();
    String str = studentId.toString().replaceAll('[', '');
    str = str.replaceAll(']', '');
    map.putIfAbsent('studentId', () => str);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getStudentInfo'], queryParameters: map);
    //print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        List<dynamic> list = responseModel.data;
        list.forEach((item) {
          UserInfoVo userInfoVo = UserInfoVo.fromJson(item);
          result.add(userInfoVo);
        });
        return result;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///获取我的好友
  static Future<List<MyFriendsVo>> getAllMyFriends(BuildContext context) async {
    ResponseModel responseModel =
        await get(context, method: userPath.servicePath['getAllMyFriends']);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        List<MyFriendsVo> res = [];
        List<dynamic> list = responseModel.data;
        list.forEach((item) {
          MyFriendsVo myFriendsVo = MyFriendsVo.fromJson(item);
          res.add(myFriendsVo);
        });
        return res;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///批量查好友资料
  static Future<List<UserInfoVo>> getFriendsUserInfo(
      BuildContext context, List<String> friendIds) async {
    List<UserInfoVo> result = [];
    if (friendIds.isEmpty) {
      return result;
    }
    Map<String, dynamic> map = new Map();
    String str = friendIds.toString().replaceAll('[', '');
    str = str.replaceAll(']', '');
    map.putIfAbsent('friendId', () => str);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['getFriendsUserInfo'],
        queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        List<dynamic> list = responseModel.data;
        list.forEach((item) {
          UserInfoVo userInfoVo = UserInfoVo.fromJson(item);
          result.add(userInfoVo);
        });
        return result;
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ///是否是好友关系
  static Future<bool> IsMyFriend(BuildContext context, String friendId) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('friendId', () => friendId);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['IsMyFriend'], queryParameters: map);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return false;
  }

  ///同意添加好友
  static Future<bool> agreeFriend(
      BuildContext context, String sid, String friendId) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('sid', () => sid);
    map.putIfAbsent('friendId', () => friendId);
    ResponseModel responseModel = await get(context,
        method: userPath.servicePath['agreeFriend'], queryParameters: map);
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return false;
  }

  ///上传base64图片, 压缩图片
  static Future<UserHeadImage> uploadChatImageBase64(
      BuildContext context, String path,
      {timeout = 30 * 1000}) async {
    //Map<String, dynamic> map = new Map();
    ///压缩
    File fp = await ImageCompressUtil.getCompressImgWH(
      path: path,
      targetWidth: 600,
    );
    String base64 = await Base64Util.image2Base64(fp.path);
    ResponseModel responseModel = await post(context,
        timeout: timeout,
        method: userPath.servicePath['uploadChatImageBase64'],
        data: base64);
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        UserHeadImage userHeadImage =
            UserHeadImage.fromJson(responseModel.data);
        return userHeadImage;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }

  /**
   * 视频小于8M，高质量压缩
   * 视频大于8M，视频品质压缩
   * 视频大于100M，默认压缩，
   * 大于150M，低质量压缩
   */

  ///上传聊天视频, 压缩图片
  static Future<String> uploadChatVideo(BuildContext context, String videoPath,
      {timeout = 3 * 60 * 1000,
      ProgressCallback onSendProgress,
      compressSize = 8}) async {
    File file = File(videoPath);
    print(file.statSync().type.toString());

    ///compress
    MediaInfo mediaInfo = await VideoCompressUtil.LimitCompressVideo(videoPath);
    if (file.existsSync()) {
      var name = mediaInfo.path.substring(
          mediaInfo.path.lastIndexOf("/") + 1, mediaInfo.path.length);
      FormData formData = FormData.fromMap({
        "video": MultipartFile.fromFileSync(mediaInfo.path, filename: name),
      });
      ResponseModel responseModel = await post(context,
          timeout: timeout,
          method: userPath.servicePath['uploadChatVideo'],
          data: formData,
          onSendProgress: onSendProgress);
      print(responseModel);
      if (responseModel != null) {
        if (responseModel.code == 1) {
          return responseModel.data;
        }
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  static Future<dynamic> uploadCourseFile(
    BuildContext context, {
    @required String filePath,
    @required String fineName,
    String courseId,
    timeout = -1,
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) async {
    if (ObjectUtil.isNotEmpty(filePath)) {
      String mimeType = mime(filePath);
      File fp = File(filePath);
      print(fp.statSync().type.toString());
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(filePath,
            filename: fineName, contentType: MediaType.parse(mimeType)),
      });
      Map<String, dynamic> map = Map();
      map.putIfAbsent('courseId', () => courseId);
      ResponseModel responseModel = await post(context,
          timeout: timeout,
          method: userPath.servicePath['uploadCourseFile'],
          data: formData,
          requestmap: map,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken);
      print(responseModel);
      if (responseModel != null) {
        if (responseModel.code == 1) {
          return responseModel.data;
        }
      } else {
        throw responseModel.errors[0].message;
      }
    }
    return null;
  }

  ////////////////////software/////////////////////
  static Future<bool> software_updateListenUserModel(
      BuildContext context,
      String listenUserId,
      String phoneNumber,
      String address,
      int status) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('listenUserId', () => listenUserId);
    map.putIfAbsent('phoneNumber', () => phoneNumber);
    map.putIfAbsent('address', () => address);
    map.putIfAbsent('status', () => status);
    ResponseModel responseModel =
        await post(context, method: 'updateListenUserModel', requestmap: map);
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return false;
  }

  ///获取文件列表
  static Future<List<dynamic>> getFileInfoList(BuildContext context,
      {courseId, type = 0}) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent('courseId', () => courseId);
    map.putIfAbsent('type', () => type);
    ResponseModel responseModel = await get(
      context,
      method: userPath.servicePath['getFileInfoList'],
      queryParameters: map,
    );
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }

  ///获取文件列表
  static Future<List<dynamic>> deleteCourseFile(BuildContext context,
      {List<String> fid, String courseId, type = 0}) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent('fid', () => fid);
    map.putIfAbsent('courseId', () => courseId);
    map.putIfAbsent('type', () => type);
    ResponseModel responseModel = await post(
      context,
      method: userPath.servicePath['deleteCourseFile'],
      requestmap: map,
    );
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }

  ///获取话题
  static Future<List<TopicVo>> getTopicList(BuildContext context,
      {@required String courseId, String userId}) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent('courseId', () => courseId);
    if (ObjectUtil.isNotEmpty(userId)) {
      map.putIfAbsent('userId', () => userId);
    }
    ResponseModel responseModel = await post(
      context,
      method: userPath.servicePath['getTopicList'],
      requestmap: map,
    );
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        List data = responseModel.data;
        List<TopicVo> res = [];
        data.forEach((element) {
          res.add(TopicVo.fromJson(element));
        });
        return res;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }

  ///createTopic
  static Future<dynamic> createTopic(
      BuildContext context, TopicDto topicDto) async {
    ResponseModel responseModel = await post(
      context,
      method: userPath.servicePath['createTopic'],
      data: topicDto.toJson(),
    );
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }

  ///getTopicCommentList
  ///获取评论内容
  static Future<dynamic> getTopicCommentList(
      BuildContext context, String topId) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent('topId', () => topId);
    ResponseModel responseModel = await get(
      context,
      method: userPath.servicePath['getTopicCommentList'],
      queryParameters: map,
    );
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }

  ///发表评论
  static Future<bool> createTopicComment(
      BuildContext context, TopicCommentDto dto) async {
    print(dto.toString());
    ResponseModel responseModel = await post(
      context,
      method: userPath.servicePath['createTopicComment'],
      data: dto.toJson(),
    );
    if (responseModel != null) {
      if (responseModel.code == 1) {
        print(responseModel.data);
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }

  ///点赞
  static Future<bool> commendationTop(
      BuildContext context, String topId,{like=true}) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent('topId', () => topId);
    map.putIfAbsent('like', () => like);
    ResponseModel responseModel = await post(
      context,
      method: userPath.servicePath['commendationTop'],
      requestmap: map,
    );
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      }
    } else {
      throw responseModel.errors[0].message;
    }
    return null;
  }
}
