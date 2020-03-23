import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

///房主头像信息
class TeacherImageInfoWidget extends StatelessWidget {
  final String teacherId;

  TeacherImageInfoWidget({Key key, @required this.teacherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // teacherInfo=Provide.value<UserProvide>(context).tacherInfo;
//    return Provide<UserProvide>(builder: (context,child,data){
////      print("***${data.tacherInfo}");
//////      String url=(data.tacherInfo.faceImage.isNotEmpty)?data.tacherInfo.faceImage:'';
//////      String name=(data.tacherInfo.identityVo.realName.isNotEmpty)?data.tacherInfo.identityVo.realName:data.tacherInfo.nickname;
////      return _teacherImageInfo('','');
////    },);

    return FutureBuilder(
      future:
          Provide.value<UserProvide>(context).getTeacherInfo(context,teacherId: teacherId),
      builder: (context, snaphot) {
        if (snaphot.hasData) {
          print(snaphot.data.identityVo);
          String url = (snaphot.data.faceImage.isNotEmpty)
              ? snaphot.data.faceImage
              : '';
          String name = (snaphot.data.identityVo.realName.toString().isNotEmpty)
              ? snaphot.data.identityVo.realName
              : snaphot.data.nickname;
          return _teacherImageInfo(url, name);
        }
        return _teacherImageInfo(null,'');
      },
    );
  }

  ///房主头像信息
  Widget _teacherImageInfo(url, name) {
    return Container(
      // color: Colors.grey,
      padding: EdgeInsets.only(left: 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircleAvatar(
            minRadius: ScreenUtil.textScaleFactory*20,
            maxRadius: ScreenUtil.textScaleFactory*20,
            backgroundImage: (url!=null)?NetworkImage(url):AssetImage('assets/img/dpic.png'),
          ),
          Text(
            name,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
