import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _logoController;
  Tween _scaleTween;
  CurvedAnimation _logoAnimation;

  @override
  void initState() {
    super.initState();
    _scaleTween = Tween(begin: 0, end: 1);
    _logoController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..drive(_scaleTween);
    Future.delayed(Duration(milliseconds: 500), () {
      _logoController.forward();
    });
    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutQuart);

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 200), () {
          goPage();
        });
      }
    });

  }

  void goPage() async {
    await Application.initSp();
    Provide.value<UserModelProvide>(context).initUser(context);
    UserModel user = Provide.value<UserModelProvide>(context).user;
    if (user != null) {
      DateTime time = DateTime.tryParse(user.loginDate);
      time = time.add(Duration(seconds: user.expire));
      if (DateTime.now().isBefore(time)) {
        ///token 是否过期
        UserMethod.refreshLogin(
                context, Provide.value<UserModelProvide>(context).username)
            .then((newUser) {
          ///更新 user 时间
          if (newUser != null) {
            Application.sp.setString('user', json.encode(newUser.toJson()));
          }
        }).catchError((onError) {
          Fluttertoast.showToast(msg: onError.toString());
        });
        NavigatorUtil.goHomePage(context);
        return null;
      }
    }
    String username = Provide.value<UserModelProvide>(context).username;
    //String pwd=Provide.value<UserModelProvide>(context).pwd;
    NavigatorUtil.goLoginPage(
      context,
      username: username,
    );
    //Application.router.navigateTo(context, Routes.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    //NetUtils.init();
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1300)..init(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ScaleTransition(
          scale: _logoAnimation,
          child: Hero(
              tag: 'logo',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/img/appIcon.png',
                    fit: BoxFit.contain,
                    width: ScreenUtil().setWidth(150),
                    height: ScreenUtil().setHeight(150),
                  ),
                  Text(
                    '智慧课堂辅助App',
                    style: TextStyle(
                        color: Colors.pink, fontSize: ScreenUtil().setSp(50)),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logoController.dispose();
  }
}
