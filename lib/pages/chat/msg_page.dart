import 'package:course_app/provide/chat/chat_message_provide.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class MsgPage extends StatefulWidget {
  @override
  _MsgPageState createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight,
      //color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Provide<ChatMessageProvide>(
        builder: (_, child, data) {
          if (data.messageList.length == 0)
            return NoDataWidget(
                path: 'assets/img/nodata2.png', title: '暂无消息记录,赶快来和好友互动吧');
          return EasyRefresh.custom(
            header: MaterialHeader(),
            slivers: <Widget>[
              SliverSafeArea(
                //安全区
                sliver: SliverPadding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        print('list  ${data.messageList[index].msg}');
                        return data.messageList[index];
                      },
                      childCount: data.messageList.length,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

//class MsgPage extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: ScreenUtil.screenWidth,
//      height: ScreenUtil.screenHeight,
//      //color: Colors.white,
//      margin: EdgeInsets.only(top: 10),
//      child: EasyRefresh.custom(
//        header: MaterialHeader(),
//        slivers: <Widget>[
//          SliverSafeArea(
//            //安全区
//            sliver: SliverPadding(
//              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
//              sliver: SliverList(
//                delegate: SliverChildBuilderDelegate(
//                  (BuildContext context, int index) {
//                    return PersonItem('0',
//                        headUrl: '',
//                        username: '包叔',
//                        displayMsg: true,
//                        msg: '哈哈哈',
//                        time: '2019-01-05 15:46',
//                        unRead: 1);
//                  },
//                  childCount: 5,
//                ),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
