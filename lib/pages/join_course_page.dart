import 'package:common_utils/common_utils.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:course_app/config/service_url.dart';
class JoinCoursePage extends StatefulWidget {
  final id;
  JoinCoursePage({Key key, this.id}) : super(key: key);

  @override
  _JoinCoursePageState createState() => _JoinCoursePageState();
}

class _JoinCoursePageState extends State<JoinCoursePage> {
  //bool autovalidate;
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    //autovalidate = false;
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '加入课程',
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(40)),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              //TODO 加课
              onSubmit(context);
            },
            child: Container(
              padding: EdgeInsets.all(2),
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setHeight(60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text(
                  '确认',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
        child: EditWidget(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget EditWidget() {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            '通过6位邀请码加入课堂',
            style: TextStyle(
                color: Colors.black26, fontSize: ScreenUtil().setSp(30)),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
          margin: EdgeInsets.only(top: 10, left: 30, right: 30),
          decoration: BoxDecoration(
              color: Colors.white, border: Border.all(color: Colors.black12)),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 1,
            //maxLength: 6,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              hintText: '输入邀请码',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20.0),
              border: InputBorder.none,
            ),
            autofocus: true,
            style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(80),
            ),
            textAlign: TextAlign.justify,
            onChanged: (str) {
              print(str);
              if (str.length == 6) {
                //autovalidate = true;
                onSubmit(context);
              }
            },
            onSaved: (str) {
              print('onSaved${str}');
            },
            //autovalidate: autovalidate,
            //validator: validateCode,
          ),
        ),
        Provide<CourseProvide>(
          builder: (context, child, data) {
            if (data.code == Code.error) {
              return Padding(
                padding: EdgeInsets.only(top: 10, right: 115),
                child: Text(
                  Provide.value<CourseProvide>(context).backMessage,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            } else if (data.code == Code.loading) {
              return Padding(
                padding: EdgeInsets.only(top: 10, right: 115),
                child: Text(
                  '正在加入班级..',
                  style: TextStyle(
                    color: Colors.black26,
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }

  ///确认加课
  onSubmit(context) async {
    String value = _controller.value.text;
    if (value.length == 6 && !RegexUtil.isZh(value)) {
      print('*******');
      Provide.value<CourseProvide>(context).changeCode(codes: Code.loading);
      Provide.value<CourseProvide>(context)
          .postJoinCode(Provide.value<UserProvide>(context).userId,value)
          .then((item) {
        //TODO 处理加课
        print(item);
        if (item!=null) {
          Navigator.pop(context);
          //Application.router.navigateTo(context, Routes.classRoomPage);
          Application.router.navigateTo(
              context,
              Routes.classRoomPage +
                  '?' +
                  'studentNums=${item.member}'
                      '&classtitle=${Uri.encodeComponent(item.title)}'
                      '&courseNumber=${item.courseNumber}'
                      '&joinCode=${item.joincode}'
                      '&teacherId=${item.teacherId}'
                      '&courseId=${item.courseId}');
        }
      });
    } else {
      String title;
      if (value.length == 0) {
        title = '邀请码不能为空';
      } else if (value.length < 6) {
        title = '邀请码不足6位';
      }
      Fluttertoast.showToast(
          msg: title,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
    _focusNode.unfocus();
  }
}
