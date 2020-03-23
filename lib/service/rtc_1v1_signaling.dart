import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/utils/data_content.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:random_string/random_string.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

//信令状态的回调
typedef void SignalingStateCallback(SignalingState state);
//媒体流的状态回调
typedef void StreamStateCallback(MediaStream stream);
//对方进入房间的回调
typedef void OtherEventCallback(dynamic event);

//信令状态
enum SignalingState {
  CallStateNew, //新进入房间
  CallStateRinging,
  CallStateInvite,
  CallStateConnected, //连接
  CallStateBye, //离开
  CallStateOpen,
  CallStateClosed,
  CallStateError,
}

class RTCSignaling {
  String _selfId = randomNumeric(6);
  final IOWebSocketChannel _channel;
  String _sessionId; //会话id
  String display; //展示名称
  Map<String, RTCPeerConnection> _peerConnections =
      Map<String, RTCPeerConnection>();

  MediaStream _localStream;
  List<MediaStream> _remoteStreams;

  SignalingStateCallback onStateChange;

  StreamStateCallback onLocalStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;

  OtherEventCallback onPeerUpdate;

  //JsonDecoder _decoder = JsonDecoder();
  JsonEncoder _encoder = JsonEncoder();

  /**
   * turn stun 服务器的地址
   */
  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {
        'urls': 'turn:47.102.97.30:3478',
        'username': 'coturn',
        'credential': '332870852',
      },
//      {
//        'urls': 'stun:47.102.97.30:3478',
//      },
    ]
  };

  /**
   * DTLS 是否开启， 一个传输安全的协议
   */
  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  /**
   * 音视频约束 ，固定的
   */

  final Map<String, dynamic> _constraints = {
    'mandatory': {'OfferToReceiveAudio': true, 'OfferToReceiveVideo': true},
    'optional': []
  };

  RTCSignaling(this._channel, {this.display});

//socket 连接
  void connect(String selfId, {String dplay}) async {
    if (!ObjectUtil.isEmptyString(display)) this.display = dplay;
    _selfId = selfId;
/*
  向信令服务发送注册消息
 */
    send('new', {
      'name': display,
      'id': _selfId,
      'user_agent': 'flutter-webrtc+${Platform.operatingSystem}'
    });
  }

//创建本地媒体流
  Future<MediaStream> creasteStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      },
    };
    //获取媒体流
    MediaStream stream = await navigator.getUserMedia(mediaConstraints);
    if (this.onLocalStream != null) {
      this.onLocalStream(stream);
    }
    return stream;
  }

//关闭本地媒体，断开socket
  void close() {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }
    _peerConnections.forEach((key, pc) {
      pc.close();
    });
  }

//切换前后摄像头
  void switchCamara() {
    _localStream?.getVideoTracks()[0].switchCamera();
  }

//邀请对方进行会话
  void invite(String peer_id) {
    this._sessionId = '$_selfId-$peer_id';
    this.onStateChange(SignalingState.CallStateNew);
    //创建一个peerconnection
    print('peer_id  :${peer_id}');
    _createPeerConnection(peer_id).then((pc) {
      _peerConnections[peer_id] = pc;
      _createOffer(peer_id, pc);
    });
  }

/*
收到消息处理逻辑
 */
  void onMessage(Map mapData) async {
    var data = mapData['data'];
    print(mapData['type']);
    switch (mapData['type']) {
      case 'peers':
        {
          //新成员加入刷新界面
          List peers = data;
          if (this.onPeerUpdate != null) {
            Map event = Map();
            event['self'] = _selfId;
            event['peers'] = peers;
            this.onPeerUpdate(event);
          }
          break;
        }
      case 'offer':
        {
          String id = data['from'];
          var description = data['description'];
          var sessionId = data['session_id'];
          _sessionId = sessionId;
          if (this.onStateChange != null)
            this.onStateChange(SignalingState.CallStateNew);
          /*
      收到offer后，创建本地的peerconnection
      之后设置远端的媒体信息，并向对端发送answer 进行应答
       */
          _createPeerConnection(id).then((pc) {
            _peerConnections[id] = pc;
            pc.setRemoteDescription(
                RTCSessionDescription(description['sdp'], description['type']));
            _createAnswer(id, pc);
          });
          break;
        }
      case 'answer':
        {
          //收到对端的answer
          String id = data['from'];
          Map description = data['description'];
          RTCPeerConnection pc = _peerConnections[id];
          print('crea ${description}');
          pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
          break;
        }
      case 'candidate':
        {
          //收到对端后选者，并添加候选者
          String id = data['from'];
          Map<String, dynamic> candidateMap = data['candidate'];
          RTCPeerConnection pc = _peerConnections[id];
          RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
              candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
          pc?.addCandidate(candidate);
          break;
        }
      case 'bye':
        {
          //离开房间
          String id = data['from'];
          _localStream?.dispose();
          _localStream = null;

          RTCPeerConnection pc = _peerConnections[id];
          pc?.close();
          _peerConnections.remove(pc);
          _sessionId = null;
          if (this.onStateChange != null) {
            this.onStateChange(SignalingState.CallStateBye);
          }
          break;
        }
      case 'keepalive':
        {
          {
            print('收到心跳检查');
          }
          break;
        }
      case 'switchCamara':{  //todo 切换摄像头
        switchCamara();
        break;
      }
    }
  }

//结束会话
  void bye() {
    send('bye', {'session_id': _sessionId, 'from': _selfId});
  }

//创建PeerConnection
  Future<RTCPeerConnection> _createPeerConnection(id) async {
    //获取本地媒体
    _localStream = await creasteStream();
    RTCPeerConnection pc = await createPeerConnection(_iceServers, _config);
    //本地媒体流赋值给peerconnection
    pc.addStream(_localStream);
    //获取候选者
    pc.onIceCandidate = (candidate) {
      send('candidate', {
        'to': id,
        'candidate': {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
        'session_id': _sessionId
      });
    };
    //获取远端媒体流
    pc.onAddStream = (stream) {
      if (this.onAddRemoteStream != null) this.onAddRemoteStream(stream);
    };

    /**
     * 移除媒体流
     */
    pc.onRemoveStream = (stream) {
      if (this.onRemoveRemoteStream != null) this.onRemoveRemoteStream(stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };
    return pc;
  }

/*
   创建offer
  */
  void _createOffer(String id, RTCPeerConnection pc) async {
    RTCSessionDescription sdp = await pc.createOffer(_constraints);
    pc.setLocalDescription(sdp);
    //向对端发送自己的媒体信息（1V1) ，如果是1VN的话是向服务器发送，SFU
    send('offer', {
      'to': id,
      'description': {'sdp': sdp.sdp, 'type': sdp.type},
      'session_id': _sessionId
    });
  }

/*
  创建answer
 */
  void _createAnswer(String id, RTCPeerConnection pc) async {
    debugPrint('_createAnswer');
    RTCSessionDescription sdp = await pc.createAnswer(_constraints);
    pc.setLocalDescription(sdp);
    /*
    发送answer
   */
    send('answer', {
      'to': id,
      'description': {'sdp': sdp.sdp, 'type': sdp.type},
      'session_id': _sessionId
    });
  }

/*
  消息发送
 */

  void send(event, data) {
    data['type'] = event;
    DataContent dataContent =
        DataContent(action: ActionEnum.VIDEO_1V1.index, data: data);
    _channel?.sink.add(_encoder.convert(dataContent));
//    _channel?.sink.add(_encoder.convert(data));
//    print('${_encoder.convert(data)}');
  }
}
