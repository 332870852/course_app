import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/pages/class_stu_list_page.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provide/provide.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

///课堂页信息头部
class ClassRoomTitleWidget extends StatelessWidget {
  final classtitle;
  final joinCode;
  final studentNums;
  final teacherId;
  final courseId;
  final String courseCid;

  ClassRoomTitleWidget(
      {Key key,
      @required this.classtitle,
      @required this.joinCode,
      @required this.studentNums,
      @required this.teacherId,
      @required this.courseId,
      @required this.courseCid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//    bool r = Provide
//        .value<UserProvide>(context)
//        .userId == teacherId;
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 25, top: 40),
      child: Column(
        children: <Widget>[
          _titleBar(context, classtitle: classtitle),
          _classRommInfo(
            context,
            joinCode: joinCode,
            studentNums: studentNums,
          ),
        ],
      ),
    );
  }

  ///头部appBar
  Widget _titleBar(context, {@required classtitle}) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: 50,
      //color: Colors.,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              '|',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w100),
            ),
          ),
          Container(
            //color: Colors.red,
            width: 250,
            child: Text(
              classtitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.textScaleFactory * 20,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  ///加课码等房间信息
  Widget _classRommInfo(BuildContext context,
      {@required joinCode, @required studentNums}) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 15),
      height: 30,
      //color: Colors.red,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              print("点击加课二维码");
              print(courseCid);
              if (!ObjectUtil.isEmptyString(courseCid)) {
                //showOverlay(context, cid: courseCid);
                showQRcode(context, cid: courseCid);
              }
            },
            child: _iconStrItem(
                Icon(
                  IconData(
                    0xe608,
                    fontFamily: Constants.IconFontFamily,
                  ),
                  color: Colors.white,
                  size: ScreenUtil.textScaleFactory * 20,
                ),
                '加课码: ${joinCode}'),
          ),
          Text(
            ' | ',
            style: TextStyle(color: Colors.white54),
          ),
          InkWell(
            onTap: () {
              ///TODO 点击同学
              print('点击同学');
              //TeacherMethod
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ClassStuListPgae(
                            courseId: courseId,
                          )));
            },
            child: _iconStrItem(
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: ScreenUtil.textScaleFactory * 20,
                ),
                '同学 ${studentNums}'),
          ),
          Text(
            ' | ',
            style: TextStyle(color: Colors.white54),
          ),
          InkWell(
            onTap: () {
              //TODO  点击成绩
              print('点击成绩');
            },
            child: _iconStrItem(
                Icon(
                  Icons.event_note,
                  color: Colors.white,
                  size: ScreenUtil.textScaleFactory * 20,
                ),
                '成绩'),
          ),
        ],
      ),
    );
  }

  Widget _iconStrItem(Icon icon, String str) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      icon,
      Text(
        ' ' + str,
        style: TextStyle(color: Colors.white),
      )
    ]);
  }

  void showQRcode(BuildContext context, {String cid}) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('${classtitle}'),
            content: Container(
              width: 300,
              height: 365,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: '${cid}',
                    width: 300,
                    height: 300,
                    placeholder: (context, url) {
                      return SpinKitFadingFour(
                        color: Colors.grey,
                      );
                    },
                    cacheManager: DefaultCacheManager(),
                    errorWidget:
                        (BuildContext context, String url, Object error) {
                      print("assets/img/网络失败.png        ${url}");
                      return Image.asset('assets/img/网络失败.png');
                    },
                  ),
                  Flexible(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${joinCode}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: ScreenUtil.textScaleFactory * 20),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '扫描上面二维码加入课堂',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: ScreenUtil.textScaleFactory * 10),
                          )
                        ],
                      ),
                    ],
                  )),
                  Flexible(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.black26,
                      ),
                    ),
                  )
                ],
              ),
            ),
            insetAnimationCurve: Curves.fastOutSlowIn,
          );
        });
  }
}
