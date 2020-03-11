import 'package:course_app/config/constants.dart';
import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/chat/friend_model.dart';
import 'package:course_app/pages/chat/msg_page.dart';
import 'package:course_app/provide/chat/chat_contact_provide.dart';
import 'package:course_app/provide/chat/chat_message_provide.dart';
import 'package:course_app/provide/chat/chat_page_provide.dart';
import 'package:course_app/provide/chat/request_friend_provide.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/utils/scan_util.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/service/websocket_util.dart';
import 'package:course_app/test/webrtc_demo.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/utils/notifications_util.dart';
import 'package:course_app/utils/permission_util.dart';
import 'package:course_app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provide/provide.dart';
import 'package:web_socket_channel/io.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'contact_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  TabController _tabController;

//  PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    // pageController = new PageController();
    UserMethod.getAllMyFriends(context).then((fids) {
      //清除聊天状态
      Provide.value<ChatMessageProvide>(context).clearAll();
      //获取好友id
      List<String> list =
          Provide.value<ChatContactProvide>(context).queryMyFriendIds(fids);
      UserMethod.getFriendsUserInfo(context, list).then((onValue) {
        if (onValue != null) {
          //获取好友资料
          Provide.value<ChatContactProvide>(context).saveMyFriendsInfo(onValue);
        }
      });
    }).whenComplete(() {
      //联系人通知
      Provide.value<RequestFriendProvide>(context).getRequestAddFriendModel();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    //  pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<ChatPageProvide>(
      builder: (_, child, data) {
        _tabController.index = data.currentIndex;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      Provide.value<ChatPageProvide>(context)
                          .changCureentIndex(index);
                      //pageController.jumpToPage(index);
                    },
                    tabs: [
                      Tab(
                        child: titleNumber('消息', number: 0),
                      ),
                      Provide<RequestFriendProvide>(
                        builder: (context, child, data) {
                          return Tab(
                            child: titleNumber('联系人', number: data.unReadReq),
                          );
                        },
                      ),
                    ],
                    //indicatorWeight: 0.0,
                    indicatorColor: Colors.red,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black26,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              _popButtom(context),
            ],
          ),
          body: TabBarView(controller: _tabController, children: [
            MsgPage(),
            ContactPage(),
          ]),
        );
      },
    );
  }
}

Widget titleNumber(String title, {int number = 0}) {
  if (number == 0) {
    return Text(
      '${title}',
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: Stack(
          children: <Widget>[
            Text(
              '${title}',
            ),
            Positioned(
                right: 1,
                top: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Text(
                    //(number == 1) ? '${number}' : '0',
                    '${number}',
                    style: TextStyle(
                        color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                  ),
                ))
          ],
        ),
      )
    ],
  );
}

Widget _popButtom(context) {
  return PopupMenuButton(
    offset: Offset(2, 100),
    color: Colors.white.withOpacity(0.5),
    itemBuilder: (BuildContext context) {
      return <PopupMenuItem<String>>[
        PopupMenuItem(
          child: _buildPopupMenuItem(Icons.person_add, "添加好友",
              color: Colors.blueAccent),
          value: "add_friend",
        ),
        PopupMenuItem(
          child: _buildPopupMenuItem(Icons.settings_overscan, "扫一扫",
              color: Colors.blueAccent),
          value: "sao_scan",
        ),
      ];
    },
    icon: Icon(
      Icons.person_add,
      color: Colors.blue.withOpacity(0.5),
    ),
    //(Icons.add),
    onSelected: (String selected) async {
      switch (selected) {
        case 'add_friend':
          {
            NavigatorUtil.goSearchFriendPage(context);
            break;
          }
        case 'sao_scan':
          {
            CommentMethod.scanMethodUtil(context);
            break;
          }
      }
      print("点击的是$selected");
    },
  );
}

///底部菜单
_buildPopupMenuItem(IconData icons, String title, {Color color}) {
  return Row(
    children: <Widget>[
      CircleAvatar(
        child: Icon(
          icons,
          color: color,
          size: ScreenUtil().setSp(40),
        ),
        maxRadius: ScreenUtil().setSp(30),
        backgroundColor: Colors.blue.shade100,
      ),
      SizedBox(
        width: 12.0,
      ),
      Text(title)
    ],
  );
}

class LiquidLinearProgressIndicatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liquid Linear Progress Indicators"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //_AnimatedLiquidLinearProgressIndicator(),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation(Colors.red),
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.pink),
              borderColor: Colors.red,
              borderWidth: 5.0,
              direction: Axis.vertical,
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.grey),
              borderColor: Colors.blue,
              borderWidth: 5.0,
              center: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: LiquidLinearProgressIndicator(
              backgroundColor: Colors.lightGreen,
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
              direction: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }
}
