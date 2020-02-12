import 'package:course_app/utils/navigatorUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

///注册结果页
class ResultRegistPage extends StatelessWidget {
  final bool isSuccess;
  final String username;

  ResultRegistPage({Key key, @required this.isSuccess, @required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 15),
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 25),
              child: Text(
                '注册结果反馈',
                style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(50)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 200),
            ),
            (isSuccess)
                ? Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.green,
                    size: 50,
                  )
                : Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: Colors.red,
                    size: 50,
                  ),
            tipItem(isSuccess),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                NavigatorUtil.goLoginPage(context,username: username);
              },
              child: Text(
                '返回登录页',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }

  Widget tipItem(bool bSuccess) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  '账号 ${username}',
                  style: TextStyle(
                      color: (bSuccess) ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(50)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  child: Text(
                    (bSuccess) ? '注册成功!' : '注册失败!',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(50)),
                    overflow: TextOverflow.ellipsis,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
