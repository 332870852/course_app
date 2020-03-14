import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/chat/request_friend.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/chat/chat_contact_provide.dart';
import 'package:course_app/provide/chat/request_friend_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

import 'package:course_app/pages/chat/chat_friend_info_page.dart';

///好友请求列表

class ReqFriendListPage extends StatefulWidget {
  //List<RequestAddFriendModel> list;

  ReqFriendListPage({Key key}) : super(key: key);

  @override
  _ReqFriendListPageState createState() => _ReqFriendListPageState();
}

class _ReqFriendListPageState extends State<ReqFriendListPage> {
  List<String> friends = [];
  List<UserInfoVo> list=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    widget.list.forEach((item) {
//      friends.add(item.sendUserId);
//    });
  }

  @override
  Widget build(BuildContext context) {
    List<String>temp=[];
    Provide.value<RequestFriendProvide>(context).requestFriends.forEach((f){
       temp.add(f.sendUserId);
    });
    friends=temp;
    return Scaffold(
      appBar: AppBar(
        title: Text('好友请求'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: UserMethod.getFriendsUserInfo(context, friends),
            builder: (context, sna) {
              if (sna.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (sna.hasData) {
                list = sna.data;
                if (list.isEmpty) {
                  return NoDataWidget(
                      path: 'assets/img/zanwugg@2x.png', title: '暂无好友请求');
                }
                return ListView.builder(
                    itemCount:list.length,
                    itemBuilder: (context, index) {
                      return personItem(list[index]);
                    });
              } else {
                return NoDataWidget(
                    path: 'assets/img/nodata2.png', title: '加载失败');
              }
//              return Provide<RequestFriendProvide>(
//                builder: (context, child, data) {
//
//                },
//              );
            }),
      ),
    );
  }

  Widget personItem(UserInfoVo userInfoVo) {
    return Ink(
      color: Colors.white,
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatFriendInfoPage(
                        friendInfo: userInfoVo,
                        action: 2,
                      )));
        },
        leading: CircleAvatar(
            backgroundImage: (ObjectUtil.isEmptyString(userInfoVo.faceImage))
                ? AssetImage('assets/img/user.png')
                : CachedNetworkImageProvider(
                    '${userInfoVo.faceImage}',
                  )),
        title: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Wrap(
            runSpacing: 5,
            spacing: 5,
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                '${userInfoVo.nickname}',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        trailing: Container(
          width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: () async {
                    //todo  同意 1.http
                    RequestAddFriendModel r =
                    await Provide.value<RequestFriendProvide>(
                        context)
                        .getFriend(userInfoVo.userId.toString());
                    bool b = await UserMethod.agreeFriend(
                        context, r.sid, r.sendUserId);
                    if (!b) {
                      //失败
                      Fluttertoast.showToast(msg: '请求失败');
                      return;
                    }
                    //2.netty
                    Application.nettyWebSocket.getChatService().agreefriend(
                        r.sid,
                        agree: true,
                        myUserId: Provide.value<UserProvide>(context).userId,
                        friendId: r.sendUserId);
                    //3. refresh
                    print('iiii        ${userInfoVo}');
                    Provide.value<ChatContactProvide>(context)
                        .insertMyFriendsInfo(context, userInfoVo);
                    Provide.value<RequestFriendProvide>(context)
                        .removeOneBySid(r.sid).whenComplete((){
                          setState(() {
                            list.remove(userInfoVo);
                          });
                    });
                    if (Provide.value<RequestFriendProvide>(context).unReadReq <
                        1) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('同意'),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () async{
                    //todo 拒绝
                    RequestAddFriendModel r =
                        await Provide.value<RequestFriendProvide>(
                        context)
                        .getFriend(userInfoVo.userId.toString());
                    /////////////////
                    Application.nettyWebSocket.getChatService().agreefriend(
                        r.sid,
                        agree: false,
                        myUserId: Provide.value<UserProvide>(context).userId,
                        friendId: r.sendUserId);
                    Provide.value<RequestFriendProvide>(context)
                        .removeOneBySid(r.sid);
                    if (Provide.value<RequestFriendProvide>(context).unReadReq <
                        1) {
                      Navigator.pop(context);
                    }
                  },
                  textColor: Colors.white,
                  child: Text('拒绝'),
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
