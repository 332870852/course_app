import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';

class NavigatorUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: TransitionType.material);
  }

  /// 首页
  static void goHomePage(BuildContext context) {
    _navigateTo(
      context,
      Routes.homePage,
      clearStack: true,
    );
    print("打开websocket");
    Provide.value<WebSocketProvide>(context).create();
  }

  ///登录页
  static void goLoginPage(BuildContext context) {
    _navigateTo(
      context,
      Routes.loginPage,
      clearStack: true,
    );
  }
}
