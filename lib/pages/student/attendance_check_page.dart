import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:course_app/data/Attendance_student_dto.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/provide/attendance_student_provide.dart';
import 'package:course_app/provide/showAttend_provide.dart';
import 'package:course_app/service/student_method.dart';
import 'package:course_app/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

///学生签到考勤页
class AttendanceCheckPage extends StatefulWidget {
  String address;
  String time;
  final int type;
  final int attendanceStudentId;
  final String attendanceId;

  AttendanceCheckPage({Key key,
    @required this.type,
    @required this.attendanceStudentId,
    @required this.attendanceId,
    this.address = '',
    this.time = ''})
      : super(key: key);

  @override
  _AttendanceCheckPageState createState() => _AttendanceCheckPageState();
}

class _AttendanceCheckPageState extends State<AttendanceCheckPage> {
  final AttendanceStudents attendanceStudents = null;
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('确认考勤'),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new ExactAssetImage('assets/bgk/bgk1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '发布时间: ${widget.time}',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(35), color: Colors.white),
              ),
              Provide<ShowAttendProvide>(builder: (context, child, data) {
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                '${data.address}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                    (widget.type == 0) ? Type0Check() : Type1Check(data),
                    ClickBtn(data)
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget ClickBtn(ShowAttendProvide data) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: CupertinoButton(
        child:
        (data.displaycreateBnt) ? CupertinoActivityIndicator() : Text('签到'),
        onPressed: (data.displaycreateBnt)
            ? null
            : () async {
          //todo
          _focusNode.unfocus();
          String code = _controller.value.text;
          if (code
              .trim()
              .length < 6) {
            Fluttertoast.showToast(msg: '请输入六位正确的签到码');
            return null;
          }
          AttendanceStudentDto attendanceStudentDto = new AttendanceStudentDto(
              attendanceStudentId: widget.attendanceStudentId,
              attendanceId: widget.attendanceId,
              type: widget.type, attendCode: code,date: DateTime.now().toIso8601String());
          if (widget.type == 1) {
//            print('${data.latLng}');
            ///gps定位
            if (data.latLng == null || data.address.isEmpty) {
              Fluttertoast.showToast(msg: '请获取考勤定位');
              return null;
            }
            attendanceStudentDto.longitude = data.latLng.longitude;
            attendanceStudentDto.latitude = data.latLng.latitude;
            attendanceStudentDto.address = data.address;
          }
          Provide.value<ShowAttendProvide>(context).changeCreateBtn(true);

          int status = await StudentMethod.AttendanceStudentCheck(context,
              attendanceStudentDto: attendanceStudentDto)
              .catchError((onError) {
            Fluttertoast.showToast(msg: onError.toString());
          }).whenComplete(() {
            Provide.value<ShowAttendProvide>(context)
                .changeCreateBtn(false);
          });
          if (status == -1) {
            Fluttertoast.showToast(msg: '考勤失败,请重试..');
          } else if(status>-1){
            Provide.value<AttendStudentProvide>(context).updateStatus(
                widget.attendanceStudentId, status);
            Navigator.pop(context);
          }
        },
        color: Colors.blue,
      ),
    );
  }

  ///数字考勤
  Widget Type0Check() {
    return Container(
      //height: 100,
      padding: EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '数字考勤',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(35), color: Colors.white),
              ),
            ],
          ),
          InputFiled(),
        ],
      ),
    );
  }

  ///gps考勤
  Widget Type1Check(data) {
    return Container(
      //height: 100,
      padding: EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'gps考勤',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(35), color: Colors.white),
              ),
            ],
          ),
          Wrap(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: (data.addressBtn)
                        ? () async {
                      //todo 获取地点定位
                      if (await PermissionUtil.requestAmapPermission()) {
                        Provide.value<ShowAttendProvide>(context)
                            .changAddressBtn(false);
                        final location =
                        await AmapLocation.fetchLocation();
                        print(location);
                        //_location = location;
                        Provide.value<ShowAttendProvide>(context)
                            .changeAddress(
                            address: await location.address,
                            latLng: await location.latLng)
                            .whenComplete(() {
                          Provide.value<ShowAttendProvide>(context)
                              .changAddressBtn(true);
                        });
                      }
                    }
                        : null,
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    label:
                    (data.addressBtn) ? Text('获取考勤定位') : Text('正在获取定位..'),
                    color: Colors.green.withOpacity(0.2),
                    textColor: Colors.redAccent,
                    disabledColor: Colors.grey.shade300.withOpacity(0.2),
                    clipBehavior: Clip.antiAlias,
                  ),
                ],
              ),
            ],
          ),
          InputFiled(),
        ],
      ),
    );
  }

  Widget InputFiled() {
    return Container(
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
          BlacklistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]")),
          WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: InputDecoration(
          hintText: '输入6位签到码',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20.0),
          border: InputBorder.none,
        ),
        autofocus: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(80),
        ),
        textAlign: TextAlign.justify,
//        onSaved: (str) {
//          print('onSaved${str}');
//        },
      ),
    );
  }
}
