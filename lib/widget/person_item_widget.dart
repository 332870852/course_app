import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/pages/chat/chat_details_page.dart';
import 'package:course_app/pages/chat/chat_friend_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

//联系人项

class PersonItem extends StatelessWidget {
  String userId;
  UserInfoVo userInfoVo;
  String username;
  String headUrl;
  int action;
  bool displayMsg;
  String msg;
  int state;
  String time;
  int unRead;
  Color backColor;

  PersonItem(this.userId,
      {Key key,
      @required this.headUrl,
      @required this.username,
      this.userInfoVo,
      this.action = 0,
      this.displayMsg = false,
      this.msg = '',
      this.state = 0,
      this.time = '',
      this.unRead = 0,
      this.backColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (unRead > 99) {
      unRead = 99;
    }
    if (time.length > 5) {
      int len = time.length;
      time = time.substring(len - 5, len);
    }
    String stateInfo = '';
    if (state == 1) {
      stateInfo = '[在线]';
    } else {
      stateInfo = '[离线]';
    }
    return Ink(
      color: backColor,
      child: ListTile(
        onTap: () {
          //todo
          if (!displayMsg) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatFriendInfoPage(
                          friendInfo: userInfoVo,
                          action: action,
                        )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailsPage(
                          friendId: '1',
                        )));
          }
        },
        onLongPress: () {},
        leading: CircleAvatar(
            backgroundImage: (ObjectUtil.isEmptyString(headUrl))
                ? AssetImage('assets/img/user.png')
                : CachedNetworkImageProvider('${headUrl}',
                    cacheManager: DefaultCacheManager())),
        title: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Wrap(
            runSpacing: 5,
            spacing: 5,
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                '${username}',
                overflow: TextOverflow.ellipsis,
              ),
              (displayMsg)
                  ? Text(
                      '${msg}',
                      overflow: TextOverflow.ellipsis,
                    )
                  : Row(
                      children: <Widget>[
                        Text(
                          '${stateInfo}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.textScaleFactory * 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Icon(
                          Icons.fiber_manual_record,
                          color: (state == 1) ? Colors.green : Colors.black26,
                          size: ScreenUtil.textScaleFactory * 14,
                        )
                      ],
                    )
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${time}'),
            (unRead != 0)
                ? Container(
                    padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Text(
                      '${unRead}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(20)),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

///loding widget
Widget lodingWidget(ConnectionState connectionState, {int length = 0}) {
  if ((connectionState == ConnectionState.waiting)) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
            padding: EdgeInsets.only(top: 50),
            child: CupertinoActivityIndicator()),
      ], semanticIndexOffset: 0),
    );
  } else if (length == 0) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/img/nodata3.png'),
              Text(
                '暂无好友',
                style: TextStyle(color: Colors.blue.shade200),
              ),
            ],
          ),
        ),
      ], semanticIndexOffset: 0),
    );
  }
}

///no date
///

Widget NoDataWidget({@required String path, String title, double top = 50.0}) {
  return Container(
    padding: EdgeInsets.only(top: top),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 80,
            maxHeight: 80,
          ),
          child: Image.asset(
            '${path}',
          ),
        ),
        Text(
          '${title}',
          style: TextStyle(color: Colors.blue.shade200),
        ),
      ],
    ),
  );
}
