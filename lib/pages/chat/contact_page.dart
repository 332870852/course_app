import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/chat/friend_model.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/pages/chat/req_friend_list_page.dart';
import 'package:course_app/provide/chat/chat_contact_provide.dart';
import 'package:course_app/provide/chat/request_friend_provide.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:flutter/cupertino.dart';

//联系人页面
class ContactPage extends StatefulWidget {
  //final List<MyFriendsVo> friendList;

  ContactPage({
    Key key,
  }) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  //List<String> friendList = [];
  List<FriendItem> friend;
  List<ConcactItem> concatsItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    initFriendsId(widget.friendList);
    _tabController = TabController(length: 2, vsync: this);
    friend = [
      FriendItem(
          fiendId: '0',
          headUrl: 'http://pic31.nipic.com/20130730/789607_232633343194_2.jpg',
          username: 'ljg',
          state: 0),
      FriendItem(
          fiendId: '1',
          headUrl: 'http://pic31.nipic.com/20130730/789607_232633343194_2.jpg',
          username: '平太',
          state: 0),
    ];
    concatsItem = [
      ConcactItem(title: '操作系统', numToal: '2/5', friends: friend),
      ConcactItem(title: '编译原理', numToal: '2/5', friends: friend),
    ];

  }

//  void initFriendsId(List<MyFriendsVo> list) {
//    friendList = [];
//    if (list != null) {
//      list.forEach((item) {
//        friendList.add(item.myFriendUserId);
//      });
//    }
//  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _onRefresh() async {
    //todo 上拉刷新
    List<MyFriendsVo> f =
        await UserMethod.getAllMyFriends(context).catchError((onError) {
      Fluttertoast.showToast(msg: '刷新失败');
    });
    //initFriendsId(f); //获取好友id
    if (f!=null) {
      Provide.value<ChatContactProvide>(context)
          .getFriendsInfo(context, Provide.value<ChatContactProvide>(context).queryMyFriendIds(f));
    }
    //Provide.value<ChatContactProvide>(context).getMyFriendsInfo();

  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
//    friendList = Provide.value<ChatContactProvide>(context).myfiendsVos;
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight,
      margin: EdgeInsets.only(top: 10),
      child: FutureBuilder(
          future: Provide.value<ChatContactProvide>(context)
              .getMyFriendsInfo(),
          builder: (context, sna) {
            //print('FutureBuilder');
            return Provide<ChatContactProvide>(
              builder: (context, child, data) {
                //print('ChatContactProvide ${data.friendsInfo}');
                int currentIndex = data.currentIndex;
                return EasyRefresh.custom(
                  header: MaterialHeader(),
                  firstRefresh: true,
                  slivers: <Widget>[
                    sliverBar(),
                    tabBar(),
                    (currentIndex == 0)
                        ? safeAreaFriendBody(data.friendsInfo,
                            connectionState: sna.connectionState)
                        : safeAreaClassBody(
                            connectionState: sna.connectionState),
                  ],
                  onRefresh: () => _onRefresh(),
                );
              },
            );
          }),
    );
  }

  //班级联系人区
  Widget safeAreaClassBody(
      {ConnectionState connectionState = ConnectionState.done}) {
    return SliverSafeArea(
      //安全区
      sliver: SliverPadding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        sliver: SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return NoDataWidget(path: 'assets/img/nodata3.png', title: '暂无好友');
//              return ExpansionListPage(
//                title: '${concatsItem[index].title}',
//                items: concatsItem[index].friends,
//                numTotal: '${concatsItem[index].numToal}',
//              );
          }, childCount: 1 //concatsItem.length,
                  ),
        ),
      ),
    );
  }

  //好友
  Widget safeAreaFriendBody(List<UserInfoVo> userInfoList,
      {ConnectionState connectionState = ConnectionState.done}) {
    if (userInfoList.length < 1) {
      return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.only(top: 50),
            child: (connectionState == ConnectionState.waiting)
                ? CupertinoActivityIndicator()
                : Column(
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
    return SliverSafeArea(
      //安全区
      sliver: SliverPadding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              print('length      :${userInfoList.length} ');
              return Container(
                child: PersonItem('${userInfoList[index].userId}',
                    userInfoVo: userInfoList[index],
                    headUrl: '${userInfoList[index].faceImage}',
                    username: '${userInfoList[index].nickname}',
                    action: 0,
                    state: 1),
              );
            },
            childCount: userInfoList.length,
          ),
        ),
      ),
    );
  }

  Widget tabBar() {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
        child: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text('好友'),
            ),
            Tab(
              child: Text('班级'),
            ),
          ],
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black26,
          indicatorSize: TabBarIndicatorSize.label,
          onTap: (index) {
            Provide.value<ChatContactProvide>(context)
                .changeCurrentIndex(index);
          },
        ),
      ),
    ]));
  }

  Widget sliverBar() {
    return SliverAppBar(
//            title: Icon(
//              Icons.settings_input_svideo,
//              color: Colors.red,
//            ),
      pinned: true,
      //固定在顶部
      floating: true,
      elevation: 1.0,
      expandedHeight: 80.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: EdgeInsets.only(top: 30),
          height: 30,
          child: Provide<RequestFriendProvide>(builder: (context, child, data) {
            return Ink(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  '新朋友',
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Container(
                  width: 50,
                  child: (data.unReadReq > 0)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Text(
                                '${data.unReadReq}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(20)),
                              ),
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[Icon(Icons.chevron_right)],
                        ),
                ),
                onTap: () {
                  //todo
                  if (data.unReadReq > 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReqFriendListPage(
//                                  list: data.requestFriends,
                                )));
                    // Provide.value<RequestFriendProvide>(context)
                  } else {
                    Fluttertoast.showToast(msg: '没有好友请求');
                  }
                },
              ),
            );
          }),
        ),
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 10),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
