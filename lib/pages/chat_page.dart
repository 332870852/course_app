import 'package:course_app/config/service_url.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/service/websocket_util.dart';
import 'package:course_app/test/webrtc_demo.dart';
import 'package:course_app/utils/navigatorUtil.dart';
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
import 'user_info_page/msg_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 180,
              color: Colors.white,
              alignment: Alignment.center,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      '消息',
                    ),
                  ),
                  Tab(
                    child: Wrap(
                      direction: Axis.vertical,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Text(
                          '联系人',
                        ),
                        SpinKitWave(
                          color: Colors.red,
                          type: SpinKitWaveType.start,
                          size: ScreenUtil().setSp(30),
                        )
                      ],
                    ),
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
      ),
      body: TabBarView(controller: _tabController, children: [
        ContactPage(),
        MsgPage(),
      ]),
    );
  }
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
