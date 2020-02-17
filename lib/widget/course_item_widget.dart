import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/pages/teacher/create_course_page.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/provide/teacher/course_teacher_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/student_method.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/widget/bottom_menu_item.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:flutter/cupertino.dart';

///课堂项
class CourseItemWidget extends StatelessWidget {
  final Course item;
  final int role; //1-学生版界面，2-教师版界面，默认学生
  CourseItemWidget({Key key, @required this.item, this.role = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("999*08454");
    return Container(
      height: ScreenUtil().setHeight(330),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          _headItem(
            context,
            title: item.title,
            bgkColor: item.bgkColor,
            bgkUrl: item.bgkUrl,
            joincode: item.joincode,
            semester: item.semester,
            start: item.start,
            end: item.end,
            courseId: item.courseNumber,
          ),
          leadingItem(context,
              nums: item.member,
              courseId: item.courseId.toString(),
              title: item.title)
        ],
      ),
    );
  }

  ///学生点击底部更多
  Future _openModalBottomSheet(context,
      {@required String courseId, title}) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 160.0,
            child: Column(
              children: <Widget>[
                bottomItem(context, '置顶课程', 0),
                bottomItem(context, '退出课程', 1),
                Container(
                  height: 10,
                  color: Colors.grey.shade300,
                ),
                bottomItem(context, '取消', 2),
              ],
            ),
          );
        });
    print(option);
    switch (option) {
      case 0:
        {
          ///
          break;
        }
      case 1:
        {
          //是否确定退出课程(${title})?
          ///退出课程
          var b = await showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertionDialog(
                  title: '退出课程',
                  content: '是否确定退出课程(${title})?',
                  onOk: () {
                    Navigator.pop(context, 1);
                  },
                  onCancel: () {
                    Navigator.pop(context, 0);
                  },
                  isLoding: false,
                );
              });
          print(b);
          if (b == 1) {
            //TODO 学生退课
            StudentMethod.removeCourse(context,
                    userId: Provide.value<UserProvide>(context).userId,
                    courseId: courseId)
                .then((onValue) {
              if (onValue == true) {
                print(onValue);
                Provide.value<CourseProvide>(context).removeCourse(courseId);
                Fluttertoast.showToast(msg: '退课成功');
              } else {
                Fluttertoast.showToast(msg: '退课失败');
              }
            }).catchError((onError) {
              print("StudentMethod.removeCourse   ${onError}");
            });
          }
          break;
        }
    }
  }

  ///教师点击底部更多
  Future _openTeacherModalBottomSheet(context,
      {@required String courseId}) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 210.0,
            child: Column(
              children: <Widget>[
                bottomItem(context, '置顶课程', 0),
                bottomItem(context, '编辑课程', 1),
                bottomItem(context, '删除课程', 2),
                Container(
                  height: 10,
                  color: Colors.grey.shade300,
                ),
                bottomItem(context, '取消', 3),
              ],
            ),
          );
        });
    print(option);
    switch (option) {
      case 0:
        {
          ///
          break;
        }
      case 1:
        {
          //TODO 编辑修改课程
          //Application.router.navigateTo(context, path)
          ///修改编辑页面的控件状态
          Provide.value<CreateCourseProvide>(context).setModifyStatus(
              start: item.start,
              end: item.end,
              url: item.bgkUrl,
              bgk: item.bgkColor,
              sem: item.semester);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateCoursePage(
                        titlePage: '编辑课程',
                        isEditPage: true,

                        ///是编辑页
                        courseId: item.courseId.toString(),
                        courseTitle: '${item.title}',
                        selBgkColor: '${item.bgkColor}',
                        courseNum: '${item.courseNumber}',
                        imageUrl: '${item.bgkUrl}',
                      ))).then((onValue) {
            if (onValue != null) {
              Course course = onValue;

              ///更新修改的课程
              Provide.value<CourseTeacherProvide>(context).updateCourse(course);
            }
          });
          // TeacherMethod.updateCourse(courseDo: null)
          break;
        }
      case 2:
        {
          ///删除课程
          var b = await showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertionDialog(
                  title: '删除课程',
                  content: '是否确定删除课程(${item.title}),删除后将无法恢复?',
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
            ///确定
            //TODO 教师删除课程
            bool flag = await TeacherMethod.deleteCourse(context,
                    courseId: courseId,
                    userId: Provide.value<UserProvide>(context).userId)
                .catchError((onError) {
              Fluttertoast.showToast(msg: '删除失败${onError}');
            });
            if (flag) {
              Provide.value<CourseTeacherProvide>(context)
                  .deleteCourse(courseId);
            }
          }
          break;
        }
    }
  }

  ///首部
  Widget _headItem(
    context, {
    @required String title,
    @required String joincode,
    var bgkColor,
    String bgkUrl,
    String courseId,
    var start,
    var end,
    var semester,
  }) {
    //print("color :${bgkColor}");
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(200),
        //margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  (bgkUrl != null) ? bgkUrl : '',
                  errorListener: () {
                    //TODO 背景图片
                  },
                ),
                fit: BoxFit.cover),
            color: (Constants.bgkMap[bgkColor] != null)
                ? Constants.bgkMap[bgkColor]
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              (courseId != null && courseId.isNotEmpty)
                  ? '${title}(${courseId})'
                  : title,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(40)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _joinCodeItem(joincode),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(right: 15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          (start != null && end != null)
                              ? '${start}-${end}'
                              : '',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text((semester != null) ? '第${semester}学期' : '',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print('点击了${title}');
        //TODO 点击课程
        Application.router.navigateTo(
            context,
            Routes.classRoomPage +
                '?' +
                'studentNums=${item.member}'
                    '&classtitle=${Uri.encodeComponent(item.title)}'
                    '&courseNumber=${item.courseNumber}'
                    '&joinCode=${item.joincode}'
                    //  '&teacherName=${Uri.encodeComponent(item.teacherName)}'
                    //  '&teacherUrl=${(item.teacherUrl != null) ? Uri.encodeComponent(item.teacherUrl) : ''}'
                    '&teacherId=${item.teacherId}'
                    '&courseId=${item.courseId}&cid=${Uri.encodeComponent('${item.cid}')}');
      },
    );
  }

  ///底部
  Widget leadingItem(BuildContext context,
      {@required int nums, @required String courseId, String title}) {
    return Container(
      height: ScreenUtil().setHeight(100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _imageCount(context, nums, userIds: item.userIdSet),
          IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                //TODO  点击底部更多
                (role == 1)
                    ? _openModalBottomSheet(context,
                        courseId: courseId, title: title)
                    : _openTeacherModalBottomSheet(context, courseId: courseId);
              }),
        ],
      ),
    );
  }

  ///头像
  CircleAvatar _circleAvatar({image}) {
    var url;
    if (image != null) {
      url = image.faceImage;
    }
    //print(url);
    return CircleAvatar(
      backgroundImage:
          (url != null) ? NetworkImage(url) : AssetImage('assets/img/dpic.png'),
      minRadius: 10,
      maxRadius: 10,
    );
  }

  ///头像和人数
  Widget _imageCount(context, int nums, {userIds}) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          FutureBuilder(
              future: Provide.value<UserProvide>(context)
                  .getUserHeadImage(context, userIds),
              builder: (context, snaphot) {
                if (snaphot.hasData) {
                  Map map = snaphot.data.asMap();
                  return Row(
                    children: <Widget>[
                      _circleAvatar(image: (map[0] != null) ? map[0] : null),
                      _circleAvatar(image: (map[1] != null) ? map[1] : null),
                      _circleAvatar(image: (map[2] != null) ? map[2] : null),
                    ],
                  );
                } else {
                  return Row(
                    children: <Widget>[
                      _circleAvatar(),
                      _circleAvatar(),
                      _circleAvatar(),
                    ],
                  );
                }
              }),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              '成员${nums}人',
            ),
          )
        ],
      ),
    );
  }

  ///加课码
  Widget _joinCodeItem(String joincode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            IconData(
              0xe608,
              fontFamily: Constants.IconFontFamily,
            ),
            color: Colors.white,
            size: ScreenUtil().setSp(35),
          ),
          Text(' 加课码${joincode}',
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(30))),
        ],
      ),
    );
  }
}
