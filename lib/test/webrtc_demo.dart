import 'dart:io';

import 'package:course_app/provide/chat/chat_contact_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/rtc_1v1_signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:provide/provide.dart';




class P2PPage extends StatefulWidget {
  P2PPage({Key key, @required this.userId}) : super(key: key);
  final userId;

  @override
  _P2PPageState createState() => _P2PPageState();
}

class _P2PPageState extends State<P2PPage> {
  _P2PPageState({Key key});

  //信令对象
  RTCSignaling _signaling;

  //本地设备名称
  String _displayName =
      '${Platform.localeName.substring(0, 2)}+(${Platform.operatingSystem} )';

  //房间内的peer对象
  List<dynamic> _peers;

  var _selfId;

  //本地媒体窗口
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  //对端媒体渲染对象
  RTCVideoRenderer _remoteRendered = RTCVideoRenderer();

  //是否处于通话状态
  bool _inCalling = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initRenderers();
    _connect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _hangup();
    super.dispose();
  }

  //懒加载本地和对端渲染窗口
  void _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRendered.initialize();
  }

  //连接socket
  void _connect() async {
    if (_signaling == null) {
      _signaling = Application.nettyWebSocket.getRTCSignaling();
    }
    //信令状态回调
    _signaling.onStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.CallStateNew:
          {
            setState(() {
              _inCalling = true;
            });
          }
          break;
        case SignalingState.CallStateRinging:
        // TODO: Handle this case.
          break;
        case SignalingState.CallStateInvite:
        // TODO: Handle this case.
          break;
        case SignalingState.CallStateConnected:
        // TODO: Handle this case.
          break;
        case SignalingState.CallStateBye:
          {
            setState(() {
              _localRenderer.srcObject = null;
              _remoteRendered.srcObject = null;
              _inCalling = false;
            });
          }
          break;
        case SignalingState.CallStateOpen:
        // TODO: Handle this case.
          break;
        case SignalingState.CallStateClosed:
        // TODO: Handle this case.
          break;
        case SignalingState.CallStateError:
        // TODO: Handle this case.
          break;
      }
    };
    //更新房间成员列表
    _signaling.onPeerUpdate = ((event){
      setState(() {
        print(event);
        _selfId = event['self'];
        _peers = event['peers'];
        _peers.forEach((element) async{
           var peer = await Provide.value<ChatContactProvide>(context)
               .searchFiend(context,   element['id']);
           element['nickname']=peer.nickname;
        });
      });
    });
    //设置本地媒体
    _signaling.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
    });
    //设置远端媒体
    _signaling.onAddRemoteStream = ((stream) {
      _remoteRendered.srcObject = stream;
    });

    //服务发送注册消息 userId
    _signaling.connect(widget.userId != null ? widget.userId : '1',
        dplay: _displayName);
    ///默认关闭麦克风
    _signaling.audio = false;
  }

  //邀请对方
  void _invitePeer(peerId) async {
    print('peerId: ${peerId}');
    _signaling?.invite(peerId);
  }

  //挂断
  void _hangup() {
    _signaling?.bye();
  }

  //切换q前后摄像头
  void _switchCamera() {
    _signaling.switchCamara();
    _localRenderer.mirror = true;
  }


  String friend = '';

  Widget _buildRow(context, peer) {
    bool isSelf = (peer['id'] == _selfId);
    print(isSelf);
    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text(isSelf
              ? peer['name'] + '自己'
              : '${peer['name']} ${peer['nickname']}  '),//${peer['user_agent']}
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.videocam,color: (isSelf)?Colors.red:Colors.green,),
                  onPressed: (isSelf)?null:() {
                    _invitePeer(peer['id']);
                    setState(() {
                      friend = peer['id'];
                    });
                  },
                ),
                IconButton(
                  icon: (_signaling.audio)
                      ? Icon(Icons.mic)
                      : Icon(Icons.mic_off,color: Colors.black26,),
                  // :Icon(Icons.mic_off),
                  onPressed: () {
                    setState(() {
                      _signaling.audio = !_signaling.audio;
                    });
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P2P视频通话'),
      ),
      floatingActionButton: _inCalling
          ? SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _switchCamera,
              child: Icon(Icons.autorenew),
            ),
            FloatingActionButton(
              onPressed: _hangup,
              backgroundColor: Colors.deepOrange,
              child: Icon(
                Icons.call_end,
                color: Colors.white,
              ),
            ),
          ],
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _inCalling
          ? OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RTCVideoView(_remoteRendered),
                    decoration: BoxDecoration(color: Colors.grey),
                  )),
              Positioned(
                child: Container(
                  width:
                  orientation == Orientation.portrait ? 90.0 : 120.0,
                  height:
                  orientation == Orientation.portrait ? 120.0 : 90.0,
                  child: RTCVideoView(_localRenderer),
                  decoration: BoxDecoration(
                      color: Colors.black54.withOpacity(0.5)),
                ),
                right: 20.0,
                top: 20.0,
              ),
            ],
          ),
        );
      })
          : ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(1),
        itemBuilder: (context, index) {
          return _buildRow(context, _peers[index]);
        },
        itemCount: (_peers != null) ? _peers.length : 0,
      ),
    );
  }
}


//class P2PPage extends StatefulWidget {
//  P2PPage({Key key}) : super(key: key);
//
//  @override
//  _P2PPageState createState() => _P2PPageState();
//}
//
//class _P2PPageState extends State<P2PPage> {
//  _P2PPageState({Key key});
//
//  //信令对象
//  RTCSignaling _signaling;
//
//  //本地设备名称
//  String _displayName =
//      '${Platform.localeName.substring(0, 2)}+(${Platform.operatingSystem} )';
//
//  //房间内的peer对象
//  List<dynamic> _peers;
//
//  var _selfId;
//
//  //本地媒体窗口
//  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//
//  //对端媒体渲染对象
//  RTCVideoRenderer _remoteRendered = RTCVideoRenderer();
//
//  //是否处于通话状态
//  bool _inCalling = false;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _initRenderers();
//    _connect();
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    _hangup();
//    super.dispose();
//  }
//
//  //懒加载本地和对端渲染窗口
//  void _initRenderers() async {
//    await _localRenderer.initialize();
//    await _remoteRendered.initialize();
//  }
//
//  //连接socket
//  void _connect() async {
//    if (_signaling == null) {
//      _signaling = Application.nettyWebSocket.getRTCSignaling();
//    }
//    //信令状态回调
//    _signaling.onStateChange = (SignalingState state) {
//      switch (state) {
//        case SignalingState.CallStateNew:
//          {
//            setState(() {
//              _inCalling = true;
//            });
//          }
//          break;
//        case SignalingState.CallStateRinging:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateInvite:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateConnected:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateBye:
//          {
//            setState(() {
//              _localRenderer.srcObject = null;
//              _remoteRendered.srcObject = null;
//              _inCalling = false;
//            });
//          }
//          break;
//        case SignalingState.CallStateOpen:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateClosed:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateError:
//          // TODO: Handle this case.
//          break;
//      }
//    };
//    //更新房间成员列表
//    _signaling.onPeerUpdate = ((event) {
//      setState(() {
//        print(event);
//        _selfId = event['self'];
//        _peers = event['peers'];
//      });
//    });
//    //设置本地媒体
//    _signaling.onLocalStream = ((stream) {
//      _localRenderer.srcObject = stream;
//    });
//    //设置远端媒体
//    _signaling.onAddRemoteStream = ((stream) {
//      _remoteRendered.srcObject = stream;
//    });
//    //服务发送注册消息
//    _signaling.connect(_selfId,
//        dplay: _displayName);
//  }
//
//  //邀请对方
//  void _invitePeer(peerId) async {
//    print('peerId: ${peerId}');
//    _signaling?.invite(peerId);
//  }
//
//  //挂断
//  void _hangup() {
//    _signaling?.bye();
//  }
//
//  //切换q前后摄像头
//  void _switchCamera() {
//    _signaling.switchCamara();
//    _localRenderer.mirror = true;
//  }
//
//  Widget _buildRow(context, peer) {
//    bool isSelf = (peer['id'] == _selfId);
//    print(isSelf);
//    return ListBody(
//      children: <Widget>[
//        ListTile(
//          title: Text(isSelf
//              ? peer['name'] + 'self'
//              : '${peer['name']} ${peer['user_agent']}'),
//          trailing: SizedBox(
//            width: 100,
//            child: IconButton(
//              icon: Icon(Icons.videocam),
//              onPressed: () => _invitePeer(peer['id']),
//            ),
//          ),
//        )
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('P2P'),
//      ),
//      floatingActionButton: _inCalling
//          ? SizedBox(
//              width: 200,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  FloatingActionButton(
//                    onPressed: _switchCamera,
//                    child: Icon(Icons.autorenew),
//                  ),
//                  FloatingActionButton(
//                    onPressed: _hangup,
//                    backgroundColor: Colors.deepOrange,
//                    child: Icon(
//                      Icons.call_end,
//                      color: Colors.white,
//                    ),
//                  ),
//                ],
//              ),
//            )
//          : null,
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      body: _inCalling
//          ? OrientationBuilder(builder: (context, orientation) {
//              return Container(
//                child: Stack(
//                  children: <Widget>[
//                    Positioned(
//                        left: 0,
//                        right: 0,
//                        top: 0,
//                        bottom: 0,
//                        child: Container(
//                          margin: EdgeInsets.all(0),
//                          width: MediaQuery.of(context).size.width,
//                          height: MediaQuery.of(context).size.height,
//                          child: RTCVideoView(_remoteRendered),
//                          decoration: BoxDecoration(color: Colors.grey),
//                        )),
//                    Positioned(
//                      child: Container(
//                        width:
//                            orientation == Orientation.portrait ? 90.0 : 120.0,
//                        height:
//                            orientation == Orientation.portrait ? 120.0 : 90.0,
//                        child: RTCVideoView(_localRenderer),
//                        decoration: BoxDecoration(
//                            color: Colors.black54.withOpacity(0.5)),
//                      ),
//                      right: 20.0,
//                      top: 20.0,
//                    ),
//                  ],
//                ),
//              );
//            })
//          : ListView.builder(
//              shrinkWrap: true,
//              padding: EdgeInsets.all(1),
//              itemBuilder: (context, index) {
//                return _buildRow(context, _peers[index]);
//              },
//              itemCount: (_peers != null) ? _peers.length : 0,
//            ),
//    );
//  }
//}

//class P2PDemo extends StatefulWidget {
//  final String url;
//
//  P2PDemo({Key key, @required this.url}) : super(key: key);
//
//  @override
//  _P2PDemoState createState() => _P2PDemoState(serverUrl: url);
//}
//
//class _P2PDemoState extends State<P2PDemo> {
//  final String serverUrl;
//
//  _P2PDemoState({Key key, @required this.serverUrl});
//
//  //信令对象
//  RTCSignaling _signaling;
//
//  //本地设备名称
//  String _displayName =
//      '${Platform.localeName.substring(0, 2)}+(${Platform.operatingSystem} )';
//
//  //房间内的peer对象
//  List<dynamic> _peers;
//
//  var _selfId;
//
//  //本地媒体窗口
//  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//
//  //对端媒体渲染对象
//  RTCVideoRenderer _remoteRendered = RTCVideoRenderer();
//
//  //是否处于通话状态
//  bool _inCalling = false;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _initRenderers();
//    _connect();
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    _hangup();
//    super.dispose();
//  }
//
//  //懒加载本地和对端渲染窗口
//  void _initRenderers() async {
//    await _localRenderer.initialize();
//    await _remoteRendered.initialize();
//  }
//
//  //连接socket
//  void _connect() async {
//    if (_signaling == null) {
//      _signaling = RTCSignaling(url: serverUrl, display: _displayName);
//    }
//    //信令状态回调
//    _signaling.onStateChange = (SignalingState state) {
//      switch (state) {
//        case SignalingState.CallStateNew:
//          {
//            setState(() {
//              _inCalling = true;
//            });
//          }
//          break;
//        case SignalingState.CallStateRinging:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateInvite:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateConnected:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateBye:
//          {
//            setState(() {
//              _localRenderer.srcObject = null;
//              _remoteRendered.srcObject = null;
//              _inCalling = false;
//            });
//          }
//          break;
//        case SignalingState.CallStateOpen:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateClosed:
//          // TODO: Handle this case.
//          break;
//        case SignalingState.CallStateError:
//          // TODO: Handle this case.
//          break;
//      }
//    };
//    //更新房间成员列表
//    _signaling.onPeerUpdate = ((event) {
//      setState(() {
//        print(event);
//        _selfId = event['self'];
//        _peers = event['peers'];
//      });
//    });
//    //设置本地媒体
//    _signaling.onLocalStream = ((stream) {
//      _localRenderer.srcObject = stream;
//    });
//    //设置远端媒体
//    _signaling.onAddRemoteStream = ((stream) {
//      _remoteRendered.srcObject = stream;
//    });
//
//    //socket进行连接
//    _signaling.connect();
//  }
//
//  //邀请对方
//  void _invitePeer(peerId) async {
//    print('peerId: ${peerId}');
//    _signaling?.invite(peerId);
//  }
//
//  //挂断
//  void _hangup() {
//    _signaling?.bye();
//  }
//
//  //切换q前后摄像头
//  void _switchCamera() {
//    _signaling.switchCamara();
//    _localRenderer.mirror = true;
//  }
//
//  Widget _buildRow(context, peer) {
//    bool isSelf = (peer['id'] == _selfId);
//    print(isSelf);
//    return ListBody(
//      children: <Widget>[
//        ListTile(
//          title: Text(isSelf
//              ? peer['name'] + 'self'
//              : '${peer['name']} ${peer['user_agent']}'),
//          trailing: SizedBox(
//            width: 100,
//            child: IconButton(
//              icon: Icon(Icons.videocam),
//              onPressed: () => _invitePeer(peer['id']),
//            ),
//          ),
//        )
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('P2P demo'),
//      ),
//      floatingActionButton: _inCalling
//          ? SizedBox(
//              width: 200,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  FloatingActionButton(
//                    onPressed: _switchCamera,
//                    child: Icon(Icons.autorenew),
//                  ),
//                  FloatingActionButton(
//                    onPressed: _hangup,
//                    backgroundColor: Colors.deepOrange,
//                    child: Icon(
//                      Icons.call_end,
//                      color: Colors.white,
//                    ),
//
//                  ),
//                ],
//              ),
//            )
//          : null,
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      body: _inCalling
//          ? OrientationBuilder(builder: (context, orientation) {
//              return Container(
//                child: Stack(
//                  children: <Widget>[
//                    Positioned(
//                        left: 0,
//                        right: 0,
//                        top: 0,
//                        bottom: 0,
//                        child: Container(
//                          margin: EdgeInsets.all(0),
//                          width: MediaQuery.of(context).size.width,
//                          height: MediaQuery.of(context).size.height,
//                          child: RTCVideoView(_remoteRendered),
//                          decoration: BoxDecoration(color: Colors.grey),
//                        )),
//                    Positioned(
//                      child: Container(
//                        width:
//                            orientation == Orientation.portrait ? 90.0 : 120.0,
//                        height:
//                            orientation == Orientation.portrait ? 120.0 : 90.0,
//                        child: RTCVideoView(_localRenderer),
//                        decoration: BoxDecoration(color: Colors.black54.withOpacity(0.5)),
//                      ),
//                      right: 20.0,
//                      top: 20.0,
//                    ),
//                  ],
//                ),
//              );
//            })
//          : ListView.builder(
//              shrinkWrap: true,
//              padding: EdgeInsets.all(1),
//              itemBuilder: (context, index) {
//                return _buildRow(context, _peers[index]);
//              },
//              itemCount: (_peers != null) ? _peers.length : 0,
//            ),
//    );
//  }
//}
