import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/data/chat/chat_model.dart';
import 'package:course_app/test/float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {

  List<Chat> _list = [
//    Chat(id: '1',myUserId: '2',
//        userHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/00/rBM0u14ajuqAQpBJAAW1C4Ascnk855_80x80.png',
//        userName: '哈哈',myHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837_80x80.png',
//        content: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837.png',type: 2,createAt: 1,readAt: 1),
//    Chat(id: '1',myUserId: '2',
//        userHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/00/rBM0u14ajuqAQpBJAAW1C4Ascnk855_80x80.png',
//        userName: '哈哈',myHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837_80x80.png',
//        content: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837.png',type: 1,createAt: 0,readAt: 1),
//    Chat(id: '1',myUserId: '2',
//        userHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/00/rBM0u14ajuqAQpBJAAW1C4Ascnk855_80x80.png',
//        userName: '哈哈',myHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837_80x80.png',
//        content: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837.png',type: 1,createAt: 0,readAt: 1),
//    Chat(id: '1',myUserId: '2',
//        userHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/00/rBM0u14ajuqAQpBJAAW1C4Ascnk855_80x80.png',
//        userName: '哈哈',myHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837_80x80.png',
//        content: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837.png',type: 1,createAt: 0,readAt: 1),
//    Chat(id: '1',myUserId: '2',friendId: '2', myName: '啊啊',
//        userHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/00/rBM0u14ajuqAQpBJAAW1C4Ascnk855_80x80.png',
//        userName: '哈哈',myHeadUrl: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837_80x80.png',
//        content: 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837.png',type: 1,createAt: 0,readAt: 1),
  ];

  int _maxN = 0;
  bool _tb = true;
  int _minM = 0;
  var _controller = new ScrollController();
  bool _f = true;
  String _myHeadUrl = 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837.png';
  String _fHeadUrl = 'http://47.102.97.30:8888/group1/M00/00/02/rBM0u15CSG6ALuPnAARfy2Z_ZNk837.png';
  String _id = "";
  String _userId = "";
  TextEditingController _msgController = new TextEditingController();
  String _name = "";
  List<Chat> _listH = [];
  bool _hasMore = true;
  Timer _ct;
  bool _xs = false;
  Timer _ctinit;
  Timer _ctXl;
  Timer _ctXl2;
  Timer _ctXl1;
  int _xztp = 2;
  List<String> _mrPic = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聊天'),
        centerTitle: true,
        elevation: 0.0,
      ),
      floatingActionButton: Stack(
        children: <Widget>[
         // MenuFloatButton(courseId: widget,)
        ],
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Column(
          children: <Widget>[

            _msg(),
          ],
        ),
      ),
    );
  }


  Widget _msg() {
    return _list.length < 1
        ? Expanded(
      child: Container(
        child: Center(
          child: Text('暂无消息'),
        ),
      ),
    )
        : Expanded(
      child: GestureDetector(
        child: Container(
          child: RefreshIndicator(
            onRefresh: (){

            },
            child: NotificationListener(
              onNotification: (ScrollNotification note) {
                int n = note.metrics.pixels.toInt();
                if (n >= _maxN) {
                  _maxN = n;
                  _minM = 0;
                } else {
                  _minM++;
                }
                if (_minM > 3) {
                  _tb = false;
                  _minM = 0;
                }
              },
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return _chatList(index);
                },
                controller: _controller,
              ),
            ),
            // onRefresh: _flush,
          ),
        ),
      ),
    );
  }


  Widget _chatList(index) {
    if (_list[index].myUserId == _id) {
      // 收到的消息
      if (_list[index].type == 1) {
        // 收到的文字消息
        return Offstage(
          offstage: _xs,
          child: Container(
            padding: EdgeInsets.all(10),
//          color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  child: new ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                        imageUrl: _fHeadUrl == null
                            ? 'https://assets-store-cdn.48lu.cn/assets-store/5002cfc3bf41f67f51b1d979ca2bd637.png' +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"
                            : _fHeadUrl +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"),
                  ),
                ),
                Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 80),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, top: 10, bottom: 3, right: 10),
//                      height:1,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 7),
                              child: Text(
                                _list[index].content,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 240, 240, 240),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                null,
//                                DateTime.fromMicrosecondsSinceEpoch(
//                                    _list[index].createAt * 1000 * 1000)
//                                    .toString()
//                                    .substring(0, 19),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 200, 200, 200)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        );
      } else if (_list[index].type == 2) {
        // 收到的图片消息
//        print("xx");
        return Offstage(
          offstage: _xs,
          child: Container(
            padding: EdgeInsets.all(10),
//          color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  child: new ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                        imageUrl: _fHeadUrl == null
                            ? 'https://assets-store-cdn.48lu.cn/assets-store/5002cfc3bf41f67f51b1d979ca2bd637.png' +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"
                            : _fHeadUrl +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            content: SingleChildScrollView(
                              child: Container(
                                height: 400.0,
                                width: double.infinity,
                                child: Center(
                                  child: new Image(
                                    image: new NetworkImage(
                                        _list[index].content),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      width: 200,
                      child: Column(
                        children: <Widget>[
                          new ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: CachedNetworkImage(
                                imageUrl: _list[index].content +
                                    "?x-oss-process=image/resize,m_lfit,h_500,w_500"),
                          ),
                          Container(
                            child: Text(
                              '',
//                              DateTime.fromMicrosecondsSinceEpoch(
//                                  _list[index].createAt * 1000 * 1000)
//                                  .toString()
//                                  .substring(0, 19),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 200, 200, 200)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
//        print("xxx");
        String t = _list[index].content.split('-')[1];
        t = t.substring(0, t.length - 3);
//        print(t);
        return Offstage(
          offstage: _xs,
          child: GestureDetector(
            onTap: () {

            },
            child: Container(
              padding: EdgeInsets.all(10),
//          color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: CachedNetworkImage(
                          imageUrl: _fHeadUrl == null
                              ? 'https://assets-store-cdn.48lu.cn/assets-store/5002cfc3bf41f67f51b1d979ca2bd637.png' +
                              "?x-oss-process=image/resize,m_lfit,h_100,w_100"
                              : _fHeadUrl +
                              "?x-oss-process=image/resize,m_lfit,h_100,w_100"),
                    ),
                  ),
                  Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 80),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10, top: 10, bottom: 3, right: 10),
//                      height:1,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(Radius.circular(6))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 100,
                                padding: EdgeInsets.only(bottom: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        'img/yyl.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        t,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(255, 240, 240, 240),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'aaa',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(255, 240, 240, 240),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  '',
//                                  DateTime.fromMicrosecondsSinceEpoch(
//                                      _list[index].createAt * 1000 * 1000)
//                                      .toString()
//                                      .substring(0, 19),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 200, 200, 200)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      // 发送的消息
      if (_list[index].type == 1) {
        // 发送的文字消息
        return Offstage(
          offstage: _xs,
          child: Container(
            padding: EdgeInsets.all(10),
//          color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 80),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, bottom: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(
                              _list[index].content,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 240, 240, 240),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '',
//                              DateTime.fromMicrosecondsSinceEpoch(
//                                  _list[index].createAt * 1000 * 1000)
//                                  .toString()
//                                  .substring(0, 19),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 200, 200, 200)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: new ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                        imageUrl: _myHeadUrl == null
                            ? 'https://assets-store-cdn.48lu.cn/assets-store/5002cfc3bf41f67f51b1d979ca2bd637.png' +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"
                            : _myHeadUrl +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (_list[index].type == 2) {
        return Offstage(
          offstage: _xs,
          child: Container(
            padding: EdgeInsets.all(10),
//          color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            content: SingleChildScrollView(
                              child: Container(
                                height: 400.0,
                                width: double.infinity,
                                child: Center(
                                  child: new Image(
                                    image: new NetworkImage(
                                        _list[index].content),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      width: 200,
                      child: Column(
                        children: <Widget>[
                          new ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: CachedNetworkImage(
                                imageUrl: _list[index].content +
                                    "?x-oss-process=image/resize,m_lfit,h_500,w_500"),
                          ),
                          Container(
                            child: Text(
                              '',
//                              DateTime.fromMicrosecondsSinceEpoch(
//                                  _list[index].createAt * 1000 * 1000)
//                                  .toString()
//                                  .substring(0, 19),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 200, 200, 200)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: new ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                        imageUrl: _myHeadUrl == null
                            ? 'https://assets-store-cdn.48lu.cn/assets-store/5002cfc3bf41f67f51b1d979ca2bd637.png' +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"
                            : _myHeadUrl +
                            "?x-oss-process=image/resize,m_lfit,h_100,w_100"),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        String t = _list[index].content.split('-')[1];
        t = t.substring(0, t.length - 3);
//        print(t);
        return Offstage(
          offstage: _xs,
          child: GestureDetector(
            onTap: () {

            },
            child: Container(
              width: 100,
              padding: EdgeInsets.all(10),
//          color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 10, left: 80),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, top: 10, bottom: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              padding: EdgeInsets.only(bottom: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text('',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                        Color.fromARGB(255, 240, 240, 240),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      t,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                        Color.fromARGB(255, 240, 240, 240),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      'img/yyr.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                '',
//                                DateTime.fromMicrosecondsSinceEpoch(
//                                    _list[index].createAt * 1000 * 1000)
//                                    .toString()
//                                    .substring(0, 19),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 200, 200, 200)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: CachedNetworkImage(
                          imageUrl: _myHeadUrl == null
                              ? 'https://assets-store-cdn.48lu.cn/assets-store/5002cfc3bf41f67f51b1d979ca2bd637.png' +
                              "?x-oss-process=image/resize,m_lfit,h_100,w_100"
                              : _myHeadUrl +
                              "?x-oss-process=image/resize,m_lfit,h_100,w_100"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}
