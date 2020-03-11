import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/chat/request_friend.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/chat/chat_contact_provide.dart';
import 'package:course_app/provide/chat/chat_page_provide.dart';
import 'package:course_app/provide/chat/request_friend_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/chat_service.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/user_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

import 'chat_details_page.dart';

//好友个人资料
class ChatFriendInfoPage extends StatelessWidget {
  final UserInfoVo friendInfo;
  int action; //0-发送消息， 1-添加好友，3-同意添加
  String username;
  ChatService _chatService;

  ChatFriendInfoPage({Key key, @required this.friendInfo, this.action = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _chatService = Application.nettyWebSocket.getChatService();
    int role = friendInfo.identityVo.role;
    username = (!ObjectUtil.isEmptyString(friendInfo.phoneNumber))
        ? friendInfo.phoneNumber
        : friendInfo.email;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          EasyRefresh.custom(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('个人资料'),
                centerTitle: true,
                pinned: true,
                //固定在顶部
                floating: true,
                leading: null,
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      //todo
                    },
                    child: Text(
                      '设置',
                      style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                    ),
                    textColor: Colors.white,
                  ),
                ],
                expandedHeight: 248.0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 10),
                  title: title(),
                  background: Image.network(
                    'https://resources.ninghao.org/images/overkill.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverSafeArea(
                //安全区
                sliver: SliverPadding(
                  padding: EdgeInsets.only(
                      top: 8.0, right: 8.0, left: 20, bottom: 8.0),
                  //sliver: SliverListDemo(),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    displayItem(
                        title: (ObjectUtil.isEmptyString(friendInfo.nickname))
                            ? '${friendInfo.identityVo.realName}'
                            : '${friendInfo.identityVo.realName}(${friendInfo.nickname})',
                        iconData: Icons.people),
                    displayItem(
                        title: '${username}', iconData: Icons.contact_mail),
                    displayItem(
                        title: (role == 3) ? '学生' : '教师',
                        iconData: Icons.school),
                    (role == 3 &&
                            !ObjectUtil.isEmptyString(
                                friendInfo.identityVo.stuId))
                        ? displayItem(
                            title: '${friendInfo.identityVo.stuId}',
                            iconData: Icons.edit)
                        : displayItem(
                            title: (!ObjectUtil.isEmptyString(
                                    friendInfo.identityVo.workId))
                                ? '${friendInfo.identityVo.workId}'
                                : '暂无',
                            iconData: Icons.edit),
                  ])),
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                color: Colors.white,
                width: ScreenUtil.screenWidth,
                height: 60,
                child: (action == 1)
                    ? CupertinoButton(
                        child: Text('添加好友'),
                        color: Colors.lightBlue,
                        onPressed: () {
                          //todo 添加好友
                          String myUserId =
                              Provide.value<UserProvide>(context).userId;
                          String freindId = friendInfo.userId.toString();
                          _chatService.addFrined(
                              myUserId: myUserId, friendId: freindId);
                          Fluttertoast.showToast(msg: '已发送添加请求');
                          Navigator.pop(context);
                        })
                    : (action == 0)
                        ? CupertinoButton(
                            child: Text('发送消息'),
                            color: Colors.lightBlue,
                            onPressed: () {
                              //todo 发送消息
                              //NavigatorUtil.goChatHomePage(context);
                              var me = Provide.value<UserProvide>(context)
                                  .userInfoVo;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatDetailsPage(
                                            myUserId: me.userId.toString(),
                                            myHeadUrl: '${me.faceImage}',
                                            friendId:
                                                friendInfo.userId.toString(),
                                            friendName:
                                                '${friendInfo.identityVo.realName}(${friendInfo.nickname})',
                                            friendUrl:
                                                '${friendInfo.faceImage}',
                                            myName: '${me.nickname}',
                                          )));
                              Provide.value<ChatPageProvide>(context)
                                  .changCureentIndex(0);
                            })
                        : CupertinoButton(
                            child: Text('同意请求'),
                            color: Colors.lightBlue,
                            onPressed: () async {
                              //todo 请求
                              //1.http
                              RequestAddFriendModel r =
                                  await Provide.value<RequestFriendProvide>(
                                          context)
                                      .getFriend(friendInfo.userId.toString());
                              bool b = await UserMethod.agreeFriend(
                                  context, r.sid, r.sendUserId);
                              if (!b) {
                                //失败
                                Fluttertoast.showToast(msg: '请求失败');
                                return;
                              }
                              //2.netty
                              Application.nettyWebSocket
                                  .getChatService()
                                  .agreefriend(r.sid,
                                      agree: true,
                                      myUserId:
                                          Provide.value<UserProvide>(context)
                                              .userId,
                                      friendId: r.sendUserId);
                              Provide.value<RequestFriendProvide>(context)
                                  .removeOneBySid(r.sid);
                              //. 3.refreh
                              print('iii ${friendInfo}');
                              Provide.value<ChatContactProvide>(context)
                                  .insertMyFriendsInfo(context, friendInfo);
                              if (Provide.value<RequestFriendProvide>(context)
                                      .unReadReq >
                                  0) {
                                Navigator.pop(context);
                              } else {
                                //Navigator.popUntil(context, ModalRoute.withName('${Routes.root}'));
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            }),
              )),
        ],
      ),
    );
  }

  Widget displayItem(
      {String title, IconData iconData, Color iconColor = Colors.black26}) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 10,
        children: <Widget>[
          Icon(
            iconData,
            color: iconColor,
          ),
          Text(
            (ObjectUtil.isEmptyString(friendInfo.nickname))
                ? '(${friendInfo.nickname})${title}'
                : '${title}',
            style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Container(
      // color: Colors.red,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                  minRadius: 25,
                  maxRadius: 25,
                  backgroundImage: (ObjectUtil.isEmptyString(
                          friendInfo.faceImage))
                      ? AssetImage('assets/img/user.png')
                      : CachedNetworkImageProvider('${friendInfo.faceImage}',
                          //http://pic31.nipic.com/20130730/789607_232633343194_2.jpg
                          cacheManager: DefaultCacheManager())),
              Flexible(
                child: Container(
                  //color: Colors.red,
                  width: 185,
                  padding: EdgeInsets.only(left: 5),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            (ObjectUtil.isEmptyString(friendInfo.nickname))
                                ? '${username}'
                                : '${username}(${friendInfo.nickname})',
                            style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          (ObjectUtil.isNotEmpty(friendInfo.sex))
                              ? Image.asset(
                                  (friendInfo.sex == 0)
                                      ? "assets/img/sex0.png"
                                      : "assets/img/sex1.png",
                                  width: 15,
                                  height: 15,
                                )
                              : Icon(
                                  Icons.fiber_manual_record,
                                  size: 15,
                                  color: Colors.grey.shade400,
                                ),
                          Flexible(
                            child: Text(
                              ' ${friendInfo.identityVo.schoolName}',
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(30)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
