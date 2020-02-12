import 'package:common_utils/common_utils.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/utils/navigatorUtil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:provide/provide.dart';

class StaggerAnimation extends StatelessWidget {
  String loginName;
  String pwd;
  int loginType;
  TextEditingController usernameController;
  TextEditingController pwdController;

  StaggerAnimation(
      {Key key,
      this.buttonController,
      @required this.usernameController,
      @required this.pwdController})
      : buttonSqueezeanimation = new Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        buttomZoomOut = new Tween(
          begin: 70.0,
          end: 1000.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;

  Future<Null> _playAnimation(context) async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: buttomZoomOut.value == 70
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: new InkWell(
          onTap: () {
            //TODO 登录操作
            print("点击。。。。");
            clickLogin(context);
          },
          child: new Hero(
            tag: "fade",
            child: buttomZoomOut.value <= 200
                ? new Container(
                    width: buttonSqueezeanimation.value,
//                    width: buttomZoomOut.value == 70
//                        ? buttonSqueezeanimation.value
//                        : buttomZoomOut.value,
//                    height:
//                        buttomZoomOut.value == 70 ? 60.0 : buttomZoomOut.value,
                    height: 60,
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                      color: const Color.fromRGBO(247, 64, 106, 1.0),
                      borderRadius: buttomZoomOut.value < 400
                          ? new BorderRadius.all(const Radius.circular(30.0))
                          : new BorderRadius.all(const Radius.circular(0.0)),
                    ),
                    child: buttonSqueezeanimation.value > 75.0
                        ? new Text(
                            "登录",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          )
                        : buttomZoomOut.value < 300.0
                            ? new CircularProgressIndicator(
                                value: null,
                                strokeWidth: 1.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : null)
                : new SizedBox(
//                    width: buttomZoomOut.value,
//                    height: buttomZoomOut.value,
//                    decoration: new BoxDecoration(
//                      shape: buttomZoomOut.value < 500
//                          ? BoxShape.circle
//                          : BoxShape.rectangle,
//                      color:const Color.fromRGBO(247, 64, 106, 1.0)
//                    ),
                    ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
    });
    Provide.value<UserModelProvide>(context).addListener(() {
      print("d打开");
      NavigatorUtil.goHomePage(context);
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }

  ///点击登录按钮
  void clickLogin(context) {
    //TODO 点击登陆
    String username = usernameController.value.text;
    String password = pwdController.value.text;
    if (ObjectUtil.isEmptyString(username) ||
        ObjectUtil.isEmptyString(password)) {
      Fluttertoast.showToast(msg: '账号和密码不能为空');
      return null;
    }
    if (!RegexUtil.isMobileSimple(username) && !RegexUtil.isEmail(username)) {
      Fluttertoast.showToast(msg: '请输入正确的账号');
      return null;
    }
    if (RegexUtil.isMobileSimple(username)) {//1.
      loginName = username;
      pwd = password;
      loginType = 0;
      _playAnimation(context);
      Provide.value<UserModelProvide>(context)
          .login(context,loginName, pwd, loginType)
          .then((onValue) {
        //TODO 个人信息
        if (onValue != null&&onValue.code==1) {
          Provide.value<UserProvide>(context).saveUserInfo(onValue.userVo);
          Provide.value<UserProvide>(context).userId = onValue.userVo.userId.toString();
          Provide.value<UserProvide>(context).role=onValue.userVo.role;
        }
        print("${onValue}");
      });
    }
    if (RegexUtil.isEmail(username)) {// 2.
      loginName = username;
      pwd = password;
      loginType = 1;
      _playAnimation(context);
      Provide.value<UserModelProvide>(context)
          .login(context,loginName, pwd, loginType)
          .then((onValue) {
        if (onValue != null) {
          Provide.value<UserProvide>(context).saveUserInfo(onValue.userVo);
          Provide.value<UserProvide>(context).userId = onValue.userVo.userId.toString();
          Provide.value<UserProvide>(context).role=onValue.userVo.role;
        }
        print("${onValue}");
      });
    }
    return null;
  }
}
