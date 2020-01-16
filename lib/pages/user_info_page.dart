import 'dart:io';
import 'package:course_app/config/constants.dart';
import 'package:course_app/data/user_dto.dart';
import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/pages/user_info_page/change_user_info.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/navigator.dart';
import 'package:course_app/utils/bean_util.dart';
import 'package:course_app/widget/progress_dialog_widget.dart';
import 'package:course_app/widget/select_item_widget.dart';
import 'package:course_app/widget/user_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provide/provide.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/config/service_url.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:image_pickers/CropConfig.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:common_utils/common_utils.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人信息'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0.0,
      ),
      //backgroundColor: Colors.grey[300],
      body: Provide<UserProvide>(
        builder: (context, child, data) {
          if (data.userInfoVo != null) {
            Provide.value<UserProvide>(context).sex = data.userInfoVo.sex;
            return ListView(
              children: <Widget>[
                userInfoItem(
                    title: '头像',
                    height: null,
                    widget: UserImageWidget(
                      url: data.userInfoVo.faceImage,
                      cacheManager: DefaultCacheManager(),
                    ),
                    onTap: () {
                      //TODO
                      selectImage(context, data.userInfoVo);
                    }),
                userInfoItem(
                    title: '昵称',
                    height: 50,
                    widget: Text(
                      (data.userInfoVo.nickname.length > 12)
                          ? data.userInfoVo.nickname.substring(0, 12) + '..'
                          : data.userInfoVo.nickname,
                      style: TextStyle(color: Colors.black26, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      //TODO
                      print('昵称');
                      bool b = await NavugatorPush(context,
                          page: ChangeUserInfoPage(
                            appBarText: '更改昵称',
                            defaultvalue: data.userInfoVo.nickname,
                            info: '好昵称可以让你的朋友更容易记住你.',
                            textInputFormat: [
                              LengthLimitingTextInputFormatter(15),
                            ],
                          )).catchError((onError) {
                        Fluttertoast.showToast(
                            msg: '修改失败',
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black.withOpacity(0.6),
                            textColor: Colors.white);
                      });
                      if (b) {
                        var nickname =
                            Provide.value<UserProvide>(context).modif;
                        UserSubDto userSubDto = UserSubDto();
                        BeanUtil.UserInfoVo_TO_UserSubDto(
                            data.userInfoVo, userSubDto);
                        userSubDto.nickname = nickname;
                        UserInfoVo newUserInfo = data.userInfoVo;
                        newUserInfo.nickname = nickname;
                        _changUserinfo(context, newUserInfo, userSubDto);
                      }
                    }),
                userInfoItem(
                    title: '性别',
                    height: 50,
                    widget: (data.sex == null)
                        ? null
                        : ((data.userInfoVo.sex == 0)
                            ? Image.asset("assets/img/sex0.png")
                            : Image.asset("assets/img/sex1.png")),
                    onTap: () async {
                      //TODO
                      print('性别');
                      int sex = await _openSimpleDialog(
                        context,
                      );
                      //print("8888  ${Provide.value<UserProvide>(context).sex}");
                      if ((sex != Provide.value<UserProvide>(context).sex &&
                              sex != 2) ||
                          Provide.value<UserProvide>(context).sex == null) {
                        Provide.value<UserProvide>(context).sex = sex;
                        UserSubDto userSubDto = UserSubDto();
                        BeanUtil.UserInfoVo_TO_UserSubDto(
                            data.userInfoVo, userSubDto);
                        userSubDto.sex = sex;
                        UserInfoVo newUserInfo = data.userInfoVo;
                        newUserInfo.sex = sex;
                        _changUserinfo(context, newUserInfo, userSubDto);
                      }
                    }),
                userInfoItem(
                    title: '二维码名片',
                    height: 50,
                    widget: Icon(
                      IconData(
                        0xe608,
                        fontFamily: Constants.IconFontFamily,
                      ),
                      color: Colors.black26,
                      size: ScreenUtil().setSp(35),
                    ),
                    onTap: () {
                      //TODO
                      print('二维码名片');
                    }),
                userInfoItem(
                    title: '姓名',
                    height: 50,
                    widget: Text(
                      (data.userInfoVo.identityVo != null
                          ? data.userInfoVo.identityVo.realName
                          : ''),
                      style: TextStyle(color: Colors.black26, fontSize: 20),
                    ),
                    onTap: () async {
                      //TODO
                      print('姓名');
                      bool b = await NavugatorPush(context,
                          page: ChangeUserInfoPage(
                            appBarText: '更改真实姓名',
                            defaultvalue: (data.userInfoVo.identityVo != null
                                ? data.userInfoVo.identityVo.realName
                                : ''),
                            info: '真实姓名可以让同校同学更容易记住你.',
                            textInputFormat: [
                              WhitelistingTextInputFormatter(
                                  RegExp("[a-zA-Z]|[\u4e00-\u9fa5]")),
                              LengthLimitingTextInputFormatter(6),
                            ],
                          ));
                      if (b) {
                        var name = Provide.value<UserProvide>(context).modif;
                        UserSubDto userSubDto = UserSubDto();
                        BeanUtil.UserInfoVo_TO_UserSubDto(
                            data.userInfoVo, userSubDto);
                        userSubDto.realName = name;
                        UserInfoVo newUserInfo = data.userInfoVo;
                        newUserInfo.identityVo.realName = name;
                        _changUserinfo(context, newUserInfo, userSubDto);
                      }
                    }),
                Provide<UserProvide>(
                  builder: (context, child, data) {
                    if (data.userInfoVo.role == 2) {
                      return teacher(context,
                          data: data.userInfoVo,
                          schoolName: data.userInfoVo.identityVo.schoolName,
                          workId: data.userInfoVo.identityVo.workId,
                          classId: data.userInfoVo.identityVo.classId,
                          enterTime: '${data.userInfoVo.identityVo.time}',
                          faculty: data.userInfoVo.identityVo.faculty,
                          courseTaught: data.userInfoVo.identityVo.teach,
                          profession: data.userInfoVo.identityVo.profession);
                    } else {
                      return student(
                        context,
                        data: data.userInfoVo,
                        schoolName: data.userInfoVo.identityVo.schoolName,
                        studentId: data.userInfoVo.identityVo.stuId,
                        classId: data.userInfoVo.identityVo.classId,
                        enterTime: '${data.userInfoVo.identityVo.time}',
                      );
                    }
                  },
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  ///学生列表
  Widget student(context,
      {UserInfoVo data, studentId, schoolName, classId, String enterTime}) {
    String schoolName_d = schoolName;
    String classId_d = classId;
    if (schoolName != null && schoolName.length > 12) {
      schoolName_d = schoolName.substring(0, 12) + '..';
    }
    if (classId != null && classId.length > 12) {
      classId_d = classId.substring(0, 12) + '..';
    }
    return Column(
      children: <Widget>[
        userInfoItem(
            title: '学校',
            height: 50,
            widget: Text(
              (schoolName_d != null ? schoolName_d : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              print('学校');
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '更改学校',
                    defaultvalue: schoolName,
                    info: '完善学校信息可以让更多校友认识你',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z]|[\u4e00-\u9fa5]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                print(data);
                var schoolName = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.schoolName = schoolName;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.schoolName = schoolName;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => ChangeUserInfoPage(
//                            appBarText: '更改学校',
//                            defaultvalue: schoolName,
//                            info: '完善学校信息可以让更多校友认识你',
//                            textInputFormat: [
//                              WhitelistingTextInputFormatter(
//                                  RegExp("[a-zA-Z]|[\u4e00-\u9fa5]")),
//                              LengthLimitingTextInputFormatter(20),
//                            ],
//                          ))).then((onValue) {
//                //TODO value
//                print(onValue);
//              }
//              );
            }),
        userInfoItem(
            title: '学号',
            height: 50,
            widget: Text(
              (studentId != null ? studentId : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              print('学号');
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '更改学号',
                    defaultvalue: (studentId != null ? studentId : ''),
                    info: '完善学号信息可以让老师知道你',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[0-9]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                var stuId = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.stuId = stuId;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.stuId = stuId;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
        userInfoItem(
            title: '身份',
            height: 50,
            widget: Text(
              '学生',
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              print('身份');
              var b = await showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    Provide.value<UserProvide>(context).ChangeDialogState(0);
                    return modifIdentity(context,
                        currentRole: Provide.value<UserProvide>(context).role);
                  });
            }),
        userInfoItem(
            title: '班级',
            height: 50,
            widget: Text(
              (classId_d != null ? classId_d : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              print('班级');
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '更改班级',
                    defaultvalue: classId,
                    info: '完善班级信息',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z]|[0-9]|[\u4e00-\u9fa5]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                var classId = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.classId = classId;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.classId = classId;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
        userInfoItem(
            title: '入学时间',
            height: 50,
            widget: Text(
              (enterTime.isNotEmpty && enterTime.length > 9
                  ? enterTime.toString().substring(0, 10)
                  : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              //TODO
              print('入学时间');
              DatePicker.showDatePicker(
                context,
                minTime: DateTime(
                  DateTime.now().year - 3,
                  DateTime.now().month,
                ),
                maxTime:
                    DateTime(DateTime.now().year + 3, DateTime.now().month),
                currentTime: DateTime.tryParse(enterTime),
                locale: LocaleType.zh,
                onConfirm: (date) {
                  print(date);
                  UserSubDto userSubDto = UserSubDto();
                  BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                  String t = date.toIso8601String();
                  userSubDto.time = t;
                  UserInfoVo newUserInfo = data;
                  newUserInfo.identityVo.time = t;
                  _changUserinfo(context, newUserInfo, userSubDto);
                },
              );
            }),
      ],
    );
  }

  Widget teacher(context,
      {UserInfoVo data,
      workId,
      String schoolName,
      String classId,
      enterTime,
      faculty,
      courseTaught,
      profession}) {
    if (schoolName != null && schoolName.length > 12) {
      schoolName = schoolName.substring(0, 12) + '..';
    }
    if (classId != null && classId.length > 12) {
      classId = classId.substring(0, 12) + '..';
    }
    return Column(
      children: <Widget>[
        userInfoItem(
            title: '学校',
            height: 50,
            widget: Text(
              (schoolName != null) ? schoolName : '',
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              print('学校');
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '更改学校',
                    defaultvalue: schoolName,
                    info: '完善学校信息可以让更多校友认识你',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z]|[\u4e00-\u9fa5]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                print(data);
                var schoolName = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.schoolName = schoolName;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.schoolName = schoolName;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
        userInfoItem(
            title: '教工号',
            height: 50,
            widget: Text(
              (workId != null ? workId : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '更改教工号',
                    defaultvalue: (workId != null ? workId : ''),
                    info: '完善教工号',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[0-9]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                var workId = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.workId = workId;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.workId = workId;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
        userInfoItem(
            title: '身份',
            height: 50,
            widget: Text(
              '教师',
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO 身份切换
              var b = await showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    Provide.value<UserProvide>(context).ChangeDialogState(0);
                    return modifIdentity(context,
                        currentRole: Provide.value<UserProvide>(context).role);
                  });
            }),
        userInfoItem(
            title: '班级',
            height: 50,
            widget: Text(
              (classId != null ? classId : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '更改班级',
                    defaultvalue: classId,
                    info: '完善班级信息',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z]|[0-9]|[\u4e00-\u9fa5]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                var classId = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.classId = classId;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.classId = classId;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
        userInfoItem(
            title: '入学时间',
            height: 50,
            widget: Text(
              (enterTime.isNotEmpty && enterTime.length > 9
                  ? enterTime.toString().substring(0, 10)
                  : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async {
              //TODO
              debugPrint('入学时间');
              DatePicker.showDatePicker(
                context,
                minTime: DateTime(
                  DateTime.now().year - 3,
                  DateTime.now().month,
                ),
                maxTime:
                    DateTime(DateTime.now().year + 3, DateTime.now().month),
                currentTime: DateTime.tryParse(enterTime),
                locale: LocaleType.zh,
                onConfirm: (date) {
                  print(date);
                  UserSubDto userSubDto = UserSubDto();
                  BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                  String t = date.toIso8601String();
                  userSubDto.time = t;
                  UserInfoVo newUserInfo = data;
                  newUserInfo.identityVo.time = t;
                  _changUserinfo(context, newUserInfo, userSubDto);
                },
              );
            }),
        userInfoItem(
            title: '院系',
            height: 50,
            widget: Text(
              (faculty != null ? faculty : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            onTap: () async{
              //TODO
              print('院系');
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '完善院系',
                    defaultvalue: faculty,
                    info: '完善院系信息',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                print(data);
                var faculty = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.faculty = faculty;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.faculty = faculty;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
        userInfoItem(
            title: '所授课程',
            height: 50,
            widget: Text(
              (courseTaught != null ? courseTaught : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async{
              //TODO
              print('所授课程');
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '完善所授课程',
                    defaultvalue: courseTaught,
                    info: '完善所授课程',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                print(data);
                var courseTaught = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.teach = courseTaught;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.teach = faculty;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
        userInfoItem(
            title: '专业',
            height: 50,
            widget: Text(
              (profession != null ? profession : ''),
              style: TextStyle(color: Colors.black26, fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async{
              //TODO
              print('专业');
              bool b = await NavugatorPush(context,
                  page: ChangeUserInfoPage(
                    appBarText: '完善专业',
                    defaultvalue: profession,
                    info: '完善专业信息',
                    textInputFormat: [
                      WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ));
              if (b) {
                print(data);
                var profession = Provide.value<UserProvide>(context).modif;
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data, userSubDto);
                userSubDto.teach = profession;
                UserInfoVo newUserInfo = data;
                newUserInfo.identityVo.profession = profession;
                _changUserinfo(context, newUserInfo, userSubDto);
              }
            }),
      ],
    );
  }

  ///封装选项
  Widget userInfoItem(
      {@required double height,
      @required String title,
      Widget widget,
      GestureTapCallback onTap}) {
    return SelectItemWidget(
      height: height,
      title: title,
      widget: widget,
      onTap: onTap,
    );
  }

  Future<bool> _changUserinfo(
      context, UserInfoVo newUserInfo, UserSubDto userSubDto,
      {bool dipalyLoding = true}) async {
    //TODO 修改个人信息
    ProgressDialog pr;
    if (dipalyLoding) {
      pr = ProgressDialogWdiget.showProgressStatic(context,
          message: '请稍后..',
          type: ProgressDialogType.Normal,
          progressWidget: CupertinoActivityIndicator(
            radius: 20.0,
          ));
    }
    bool b = await UserMethod.updateUser(
            userId: Provide.value<UserProvide>(context).userId,
            userSubDto: userSubDto)
        .whenComplete(() {
      if (dipalyLoding && pr.isShowing()) {
        pr.dismiss();
      }
    });
    if (b) {
       Provide.value<UserProvide>(context).saveUserInfo(newUserInfo);
    }
    return b;
  }

  ///dialog
  Future _openSimpleDialog(context) async {
    int _choise = Provide.value<UserProvide>(context).sex;
    print(_choise);
    final option = await showDialog(
        context: context,
        barrierDismissible: false,

        ///必须选择一个才能关闭
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('修改性别'),
            children: <Widget>[
              SimpleDialogOption(
                child: Container(
                  decoration: BoxDecoration(
                      color: (_choise == 0)
                          ? Colors.black.withOpacity(0.7)
                          : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: (_choise == 0)
                          ? Border.all(color: Colors.green)
                          : null),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset("assets/img/sex0.png"),
                      Text(
                        '  男',
                        style: TextStyle(
                            color:
                                (_choise == 0) ? Colors.purple : Colors.black,
                            fontSize: ScreenUtil().setSp(40),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              SimpleDialogOption(
                child: Container(
                  decoration: BoxDecoration(
                      color: (_choise == 1)
                          ? Colors.black.withOpacity(0.7)
                          : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: (_choise == 1)
                          ? Border.all(color: Colors.green)
                          : null),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset("assets/img/sex1.png"),
                      Text(
                        '  女',
                        style: TextStyle(
                            color:
                                (_choise == 1) ? Colors.purple : Colors.black,
                            fontSize: ScreenUtil().setSp(40),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  '取消',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: ScreenUtil().setSp(40),
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  Navigator.pop(context, 2);
                },
              ),
            ],
          );
        });
    return option;
  }

  ///选择多张图片 Select multiple images
  Future<void> selectImage(context, UserInfoVo newUserInfo) async {
    List<Media> _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showCamera: true,
        compressSize: 500,

        ///超过500KB 将压缩图片
        uiConfig: UIConfig(uiThemeColor: Color(0xffff0f50)),
        cropConfig: CropConfig(enableCrop: true, width: 1, height: 1));
    ProgressDialog pr = ProgressDialogWdiget.showProgressStatic(context,
        message: '图片上传', maxProgress: 100);
    // print(_listImagePaths[0].path);
    UserMethod.uploadFaceFile(Provide.value<UserProvide>(context).userId,
        imagePath: _listImagePaths[0].path,
        onSendProgress: (int count, int total) {
      ///更新进度条
      ProgressDialogWdiget.updateProgressStatic(pr,
          progress: (count / total) * 100, message: '上传中...');
    }).then((userHeadImage) {
      if (userHeadImage != null) {
        Provide.value<UserProvide>(context).userInfoVo.faceImage =
            userHeadImage.faceImage;
        Provide.value<UserProvide>(context).userInfoVo.faceImageBig =
            userHeadImage.faceImageBig;
        newUserInfo.faceImageBig = userHeadImage.faceImageBig;
        newUserInfo.faceImage = userHeadImage.faceImageBig;
        Provide.value<UserProvide>(context).saveUserInfo(newUserInfo);
      }
    }).whenComplete(() {
      ///关闭进度条
      pr.dismiss();
    });
  }

  ///切换身份
  Widget modifIdentity(context, {@required int currentRole}) {
    String identity = '';
    String mod = '';
    int modint;
    if (currentRole == 2) {
      identity = '教师';
      mod = '学生';
      modint = 3;
    } else {
      identity = '学生';
      mod = '教师';
      modint = 2;
    }
    return CupertinoAlertDialog(
      title: Text('切换身份'),
      content: Text('当前的身份是(${identity}),是否确定切换成(${mod})身份?'),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消'),
          textStyle: TextStyle(color: Colors.grey),
        ),
        Provide<UserProvide>(
          builder: (context, child, data) {
            return CupertinoDialogAction(
              onPressed: () async {
                Provide.value<UserProvide>(context).ChangeDialogState(1);
                UserSubDto userSubDto = UserSubDto();
                BeanUtil.UserInfoVo_TO_UserSubDto(data.userInfoVo, userSubDto);
                userSubDto.role = modint;
                UserInfoVo newUserInfo = data.userInfoVo;
                newUserInfo.role = modint;
                newUserInfo.identityVo.role = modint;
                bool b = await _changUserinfo(context, newUserInfo, userSubDto,
                    dipalyLoding: false);
                if (b) {
                  ///再次刷新用户资料
                  Provide.value<UserProvide>(context).getUserInfo(
                      userId: Provide.value<UserProvide>(context).userId);
                  Navigator.pop(context);
                } else {
                  Provide.value<UserProvide>(context).ChangeDialogState(2);
                }

                ///加载中
              },
              child: (data.dialogState == 0)
                  ? Text('确认')
                  : (data.dialogState == 1)
                      ? CupertinoActivityIndicator()
                      : Text('重试'),
            );
          },
        ),
      ],
    );
  }
}
