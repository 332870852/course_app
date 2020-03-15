import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/pages/soft/soft_info_page.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/test/soft_ware.dart';
import 'package:course_app/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_bus/flutter_event_bus/Subscription.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';

class SoftWarePage extends StatefulWidget {
  List list;
  final pwd;

  SoftWarePage({Key key, @required this.list, @required this.pwd})
      : super(key: key);

  @override
  _SoftWarePageState createState() => _SoftWarePageState();
}

class _SoftWarePageState extends State<SoftWarePage> {
 // List<AlbumModelEntity> _list = [];
  List<String> userIds = [];
  Subscription _subscription;

  ///获取在线用户
  getOnlineUser() {
    Application.nettyWebSocket.getSoftWareChannel().sendListenuser();
  }



  @override
  void initState() {
    super.initState();
    print('list L :${widget.list}');
    // userIds
    widget.list.forEach((item) {
      userIds.add(item.toString());
    });

    debugPrint('userIds  ${userIds}');
    _subscription =
        Application.eventBus.respond<SoftWareBody>((SoftWareBody soft) {
      if (soft.method == 'onlineuser') {
        debugPrint('onlineuser');
        List list = soft.data;
        if (list != null) {
          userIds.clear();
          list.forEach((item) {
            userIds.add(item.toString());
          });
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                Application.nettyWebSocket
                    .getSoftWareChannel()
                    .sendListenuser(pwd: '${widget.pwd}');
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: FutureBuilder<List<UserInfoVo>>(
            future: UserMethod.getStudentInfo(context, widget.list),
            builder: (_, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return CupertinoActivityIndicator();
              }
              if (data.hasData) {
                return ListView.builder(
                  itemBuilder: (_, index) {
                    return Item(data.data[index]);
                  },
                  itemCount: data.data.length,
                );
              }
              return Center(
                child: Text('暂无数据'),
              );
            }),
      ),
    );
  }

  Widget Item(UserInfoVo userInfoVo, {backColor = Colors.white}) {
    print('item       :${userInfoVo}');
    bool flag = (Provide.value<UserProvide>(context).userId ==
        userInfoVo.userId.toString());
    return Ink(
      color: backColor,
      child: ListTile(
        onTap:  () {
                //todo
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SoftInfoPage(
                              userInfoVo: userInfoVo,
                            )));
              },
        onLongPress: () {},
        leading: CircleAvatar(
            backgroundImage: (ObjectUtil.isEmptyString(userInfoVo.faceImage))
                ? AssetImage('assets/img/user.png')
                : CachedNetworkImageProvider('${userInfoVo.faceImage}',
                    cacheManager: DefaultCacheManager())),
        title: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Wrap(
            runSpacing: 5,
            spacing: 5,
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                (flag)
                    ? '我 '
                    : '${userInfoVo.nickname}(${userInfoVo.identityVo.realName})',
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Text(
                    '在线',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil().setSp(28)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.fiber_manual_record,
                    color: Colors.green,
                    size: ScreenUtil().setSp(28),
                  )
                ],
              ),
            ],
          ),
        ),
        trailing: (userInfoVo.sex == null)
            ? null
            : ((userInfoVo.sex == 0)
                ? Image.asset("assets/img/sex0.png")
                : Image.asset("assets/img/sex1.png")),
      ),
    );
  }
}
