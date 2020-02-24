import 'package:common_utils/common_utils.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/utils/navigatorUtil.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:course_app/widget/select_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

///账号管理页
class AdminAccoutPage extends StatelessWidget {
  AdminAccoutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.grey.shade300,
        title: Text(
          '账号与安全',
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(40)),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey.shade300,
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Column(
          children: <Widget>[
            IdItem(context),
            pwdSafeItem(context),
            exitItem(context),
          ],
        ),
      ),
    );
  }

  ///退出当前账号
  Widget exitItem(context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: SelectItemWidget(
        title: '退出当前账号',
        color: Colors.red,
        widget: Icon(
          Icons.exit_to_app,
          color: Colors.red,
        ),
        displayIcon: false,
        height: 50,
        onTap: () async {
          //todo 退出当前账号
          var b = await showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertionDialog(
                  title: '退出当前账号',
                  content: '退出当前登录账号，将需要重新登录，是否继续?',
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
            Provide.value<WebSocketProvide>(context).close();
//            String username = Provide.value<UserModelProvide>(context).username;
//            String pwd = Provide.value<UserModelProvide>(context).pwd;
            Provide.value<UserModelProvide>(context)
                .logout(context)
                .whenComplete(() {});
          }
        },
      ),
    );
  }

  ///
  Widget pwdSafeItem(context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          SelectItemWidget(
            title: '密码管理',
            height: 50,
            onTap: () {
              //todo 密码管理
              NavigatorUtil.goPwdChangePgae(context,
                  username: Provide.value<UserModelProvide>(context).username);
            },
          ),
          SelectItemWidget(
            title: '更多安全设置',
            height: 50,
            onTap: () {
              //todo 更多安全设置
            },
          ),
        ],
      ),
    );
  }

  Widget IdItem(context) {
    return Provide<UserProvide>(
      builder: (context, child, data) {
        String iphone = (ObjectUtil.isEmptyString(data.userInfoVo.phoneNumber)
            ? ''
            : data.userInfoVo.phoneNumber);
        String email = (ObjectUtil.isEmptyString(data.userInfoVo.email)
            ? ''
            : data.userInfoVo.email);
        return Column(
          children: <Widget>[
            SelectItemWidget(
              title: '标识',
              displayIcon: false,
              height: 50,
              widget: Text(
                '${data.userId}',
                style: TextStyle(color: Colors.black26),
              ),
            ),
            SelectItemWidget(
              title: '手机号',
              height: 50,
              widget: (iphone.isNotEmpty)
                  ? Row(
                      children: <Widget>[
                        Icon(
                          Icons.lock,
                          color: Colors.green,
                          size: ScreenUtil().setSp(35),
                        ),
                        Text('${iphone}'),
                      ],
                    )
                  : Text(
                      '绑定手机号',
                      style: TextStyle(color: Colors.black26),
                    ),
              onTap: () {},
            ),
            SelectItemWidget(
              title: '邮箱号',
              height: 50,
              widget: (email.isNotEmpty)
                  ? Row(
                      children: <Widget>[
                        Icon(
                          Icons.lock,
                          color: Colors.green,
                          size: ScreenUtil().setSp(35),
                        ),
                        Text('${email}'),
                      ],
                    )
                  : Text(
                      '点击绑定邮箱',
                      style: TextStyle(color: Colors.black26),
                    ),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}
