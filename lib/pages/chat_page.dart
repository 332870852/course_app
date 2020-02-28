import 'package:course_app/config/service_url.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/service/websocket_util.dart';
import 'package:course_app/test/webrtc_demo.dart';
import 'package:course_app/utils/navigatorUtil.dart';
import 'package:course_app/utils/notifications_util.dart';
import 'package:course_app/utils/permission_util.dart';
import 'package:course_app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provide/provide.dart';
import 'package:web_socket_channel/io.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          spinkit,
          IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () async {
                //Provide.value<WebSocketProvide>(context).sendMessage('还嘿嘿嘿');
                //a.show(3, "1", "5522", platformChannelSpecifics);
              }),
          RaisedButton(
            child: Text('获取单次定位'),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new P2PDemo(
                            url: 'ws://192.168.200.117:10090/ws',
                          )));
              Toast.toast(context, 'aaa');
            },
          ),
//          RaisedButton(
//            child: Text('获取连续定位'),
//            onPressed: () async {
//              if (await requestPermission()) {
//                await for (final location in AmapLocation.listenLocation()) {}
//              }
//            },
//          ),
        ],
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('000000: ' + payload);
    }
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
