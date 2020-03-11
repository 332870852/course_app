import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/pages/chat/chat_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

import '../user_provider.dart';
import 'chat_message_provide.dart';

class ConversationItem extends StatefulWidget {
  String friendId;
  String fusername;
  String friendUrl;
  bool displayDot;
  String msg;
  String time;
  int unRead;
  Color backColor;

  ConversationItem(this.friendId,
      {Key key,
      @required this.fusername,
      @required this.friendUrl,
      this.displayDot = false,
      this.msg = '',
      this.time = '',
      this.unRead = 0,
      this.backColor = Colors.white})
      : super(key: key);

  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  @override
  Widget build(BuildContext context) {
    var myUser = Provide.value<UserProvide>(context).userInfoVo;
    if (widget.unRead > 99) {
      widget.unRead = 99;
    }
    if (widget.time.length > 5) {
      int len = widget.time.length;
      widget.time = widget.time.substring(len - 5, len);
    }
    return Ink(
      color: widget.backColor,
      child: ListTile(
        onTap: () {
          //todo
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatDetailsPage(
                        myUserId: '${myUser.userId}',
                        friendId: '${widget.friendId}',
                        friendName: '${widget.fusername}',
                        myHeadUrl: '${myUser.faceImage}',
                        friendUrl: '${widget.friendUrl}',
                        myName: '${myUser.nickname}',
                      )));
          setState(() {
            widget.unRead = 0;
            widget.displayDot = false;
          });
        },
        onLongPress: () {},
        leading: CircleAvatar(
            backgroundImage: (ObjectUtil.isEmptyString(widget.friendUrl))
                ? AssetImage('assets/img/user.png')
                : CachedNetworkImageProvider('${widget.friendUrl}',
                    cacheManager: DefaultCacheManager())),
        title: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Wrap(
            runSpacing: 5,
            spacing: 5,
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                '${widget.fusername}',
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                  width: 200,
                  child: Text(
                    '${widget.msg}',
                    style: TextStyle(color: Colors.black26),
                    overflow: TextOverflow.ellipsis,
                  )),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${widget.time}'),
            (widget.displayDot)
                ? Container(
                    padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Text(
                      '${widget.unRead}',
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
