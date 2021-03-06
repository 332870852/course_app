import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/widget/bottom_clipper_widget.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:course_app/widget/user_image_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MemberPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
//    Provide.value<UserProvide>(context).getUserInfo(userId: '123');
    Provide.value<UserProvide>(context).getUserInfo();
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Provide<UserProvide>(
          builder: (context, child, data) {
            print(data.refreshBtn);
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipPath(
                      clipper: BottomClipper(),
                      child: Container(
                        color: Colors.blueAccent,
                        height: 200.0,
                      ),
                    ),
                    accountNavigator(
                        title: '账号',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.green,
                        ),
                        onTap: () {
                          //TODO 账号
                          debugPrint('账号');
                          NavigatorUtil.goAdminAccoutPage(context);
                        }),
                    listNavigator(context),
                    accountNavigator(
                        title: '退出',
                        textcolor: Colors.red,
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Colors.red,
                        ),
                        flag: false,
                        onTap: () async {
                          //TODO 退出
                          bool b = await showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertionDialog(
                                  content: '你确定退出智慧课堂?',
                                  contextColor: Colors.black,
                                  contextSize: 20,
                                  onOk: () {
                                    Navigator.pop(context, true);
                                  },
                                  onCancel: () {
                                    Navigator.pop(context, false);
                                  },
                                  isLoding: false,
                                );
                              });
                           if(b){
                             Application.nettyWebSocket.close();
                             Provide.value<WebSocketProvide>(context).close();
                             await SystemChannels.platform
                                 .invokeMethod('SystemNavigator.pop');
                           }
                          ///返回登录页
                        }),
                  ],
                ),
                Positioned(
                  right: 10,
                  top: 35,
                  child: (!data.refreshBtn)?IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: (data.refreshBtn)?null:() {
                        Provide.value<UserProvide>(context).changeRefreshBtn(true);
                        //todo 刷新个人信息
                        UserMethod.getUserInfo(
                          context,
                          userId: Provide
                              .value<UserProvide>(context)
                              .userId,
                        ).then((onValue) {
                          Provide.value<UserProvide>(context).saveUserInfo(onValue);
                        }).whenComplete((){
                          Provide.value<UserProvide>(context).changeRefreshBtn(false);
                        });
                      }):SpinKitThreeBounce(color: Colors.white),
                ),
                (data.userInfoVo != null)?UserItemWidget(
                  username: (data.userInfoVo.nickname != null)
                      ? data.userInfoVo.nickname
                      : '无',
                  identity: data.userInfoVo.role,
                  schoolName: data.userInfoVo.identityVo.schoolName,
                  url: data.userInfoVo.faceImageBig,
                ):UserItemWidget(
                  username: '无',
                  identity: 3,
                  schoolName: '',
                ),
              ],
            );
          },
        ),
    );
  }

  ///选项
  Widget ListItem({@required title, Icon icon, GestureTapCallback onTap}) {
    return Material(
      child: Ink(
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            //让下划线不占满整个控件
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            //padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: Constants.DividerWith,
                      color: Color(Constants.DividerColor))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: icon,
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black26,
                    size: 30,
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///用户列表
  Widget listNavigator(context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          ListItem(
              onTap: () {
                //TODO
                Fluttertoast.showToast(msg: '暂不支持该功能');
              },
              title: '消息推送',
              icon: Icon(
                Icons.notifications_active,
                color: Colors.blue,
              )),
          ListItem(
              title: '交易记录',
              icon: Icon(
                Icons.payment,
                color: Colors.orange,
              ),
              onTap: () {
                //TODO
                Fluttertoast.showToast(msg: '不支持该功能');
              }),
          ListItem(
              title: '关于',
              icon: Icon(
                Icons.dashboard,
                color: Colors.redAccent,
              ),
              onTap: () {
                //TODO
                NavigatorUtil.goAboutPage(context);
              }),
          ListItem(
              title: '设置',
              icon: Icon(
                Icons.settings,
                color: Colors.black26,
              ),
              onTap: () {
                //TODO
                Fluttertoast.showToast(msg: '暂不支持该功能');
              })
        ],
      ),
    );
  }

  ///
  ///账号栏
  Widget accountNavigator({@required String title,
    Icon icon,
    GestureTapCallback onTap,
    bool flag = true,
    Color textcolor = Colors.black}) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Material(
          child: Ink(
              child: InkWell(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  //让下划线不占满整个控件
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: Constants.DividerWith,
                            color: Color(Constants.DividerColor))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: icon,
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                              color: textcolor, fontWeight: FontWeight.w500),
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black26,
                          size: 30,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                onTap: onTap,
              )),
        ));
  }
}

///用户头像和信息
class UserItemWidget extends StatelessWidget {
  final url;
  final String username;
  final int identity;
  final String schoolName;

  UserItemWidget({Key key,
    @required this.username,
    @required this.identity,
    this.schoolName = '',
    this.url = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 80.0, left: 20, right: 20),
      padding: EdgeInsets.only(top: 0, bottom: 0),
      height: 120,
      width: ScreenUtil.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              //TODO 点击头像
              print("点击了头像 ${url}");
              String yulangUrl = url;
              if ((url == null || url
                  .toString()
                  .isEmpty)) {
                return;
              }
              ImagePickers.previewImage(yulangUrl);
            },
            child: UserImageWidget(
              url: url,
              cacheManager: DefaultCacheManager(),
            ),
          ),
          InkWell(
            onTap: () {
              //TODO 点击用户信息
              print("点击用户信息");
              Application.router.navigateTo(context, Routes.userInfoPage);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                nameInfo(
                    name: username, identify: identity, schoolName: schoolName),
                Icon(
                  Icons.chevron_right,
                  size: 40,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///名字学校
  Widget nameInfo({@required String name, @required int identify, schoolName}) {
    if (name.length > 5) {
      name = name.substring(0, 5) + '..';
    }
    if (schoolName.length > 9) {
      schoolName = schoolName.substring(0, 9) + '..';
    }
    if (schoolName == null || schoolName
        .toString()
        .length < 1) {
      schoolName = '暂无';
    }
    return Container(
        margin: EdgeInsets.only(left: 15.0, right: 5, top: 0, bottom: 0),
        //padding: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: ScreenUtil.textScaleFactory*160,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                        text: name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.textScaleFactory*20),
                        children: [
                          TextSpan(
                            text: (identify == 3) ? '(学生)' : '(教师)',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: ScreenUtil.textScaleFactory*20),
                          ),
                        ]),
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
                Wrap(
                  children: <Widget>[
                    Icon(
                      Icons.school,
                      color: Colors.black26,
                    ),
                    Text(
                      schoolName,
                      style: TextStyle(
                        color: Colors.black26,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
