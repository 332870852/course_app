import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/widget/bottom_clipper_widget.dart';
import 'package:course_app/widget/user_image_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
//import 'package:image_pickers/image_pickers.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Provide.value<UserProvide>(context).getUserInfo(userId: '123');
    Provide.value<UserProvide>(context).getUserInfo_sp();
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Stack(
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
                      print('账号');
                    }),
                listNavigator(),
                accountNavigator(
                    title: '退出',
                    textcolor: Colors.red,
                    icon: Icon(
                      Icons.power_settings_new,
                      color: Colors.red,
                    ),
                    flag: false,
                    onTap: () {
                      //TODO 退出
                    }),
              ],
            ),
            Provide<UserProvide>(
              builder: (context, child, data) {
                print(data.userInfoVo);
                if (data.userInfoVo != null) {
                  return UserItemWidget(
                    username: (data.userInfoVo.nickname != null)
                        ? data.userInfoVo.nickname
                        : '无',
                    identity: data.userInfoVo.role,
                    schoolName: data.userInfoVo.identityVo.schoolName,
                    url: data.userInfoVo.faceImage,
                  );
                } else {
                  return UserItemWidget(
                    username: '无',
                    identity: 3,
                    schoolName: '',
                  );
                }
              },
            ),
          ],
        ));
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
  Widget listNavigator() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          ListItem(
              onTap: () {
                //TODO
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
              }),
          ListItem(
              title: '关于',
              icon: Icon(
                Icons.dashboard,
                color: Colors.redAccent,
              ),
              onTap: () {
                //TODO
              }),
          ListItem(
              title: '设置',
              icon: Icon(
                Icons.settings,
                color: Colors.black26,
              ),
              onTap: () {
                //TODO
              })
        ],
      ),
    );
  }

  ///
  ///账号栏
  Widget accountNavigator(
      {@required String title,
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

  UserItemWidget(
      {Key key,
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
      width: ScreenUtil().width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              //TODO 点击头像
              print("点击了头像");
             // ImagePickers.previewImage(url);
            },
            child: UserImageWidget(url: url),
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
    if (schoolName == null || schoolName.toString().length < 1) {
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
                  width: 160,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                        text: name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(40)),
                        children: [
                          TextSpan(
                            text: (identify == 3) ? '(学生)' : '(教师)',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: ScreenUtil().setSp(40)),
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
