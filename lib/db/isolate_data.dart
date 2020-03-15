import 'dart:convert';

import 'package:course_app/utils/softwareUtil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:isolate';

import 'package:photo_album_manager/album_model_entity.dart';
import 'package:photo_album_manager/photo_album_manager.dart';

class Isolates {
  ///get  datat
  loadData(String method) async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_dataLoader, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;
    List<AlbumModelEntity> list =
        await _sendReceive(sendPort, "getAlbumImgAll");
    print("recive:  ${list}");
  }

  ///to do
  static _dataLoader(SendPort sendPort) async {
    ReceivePort port = ReceivePort();
    sendPort.send(port.sendPort);
    await for (var msg in port) {
      String data = msg[0];
      SendPort replayTo = msg[1];
      List<AlbumModelEntity> list = [];
      if ("getAlbumImgAll" == data) {
//        list = await PhotoAlbumManager.getDescAlbumImg(
//            maxCount: null);

        const MethodChannel _channel =
            const MethodChannel('photo_album_manager');
        List list = await _channel.invokeMethod('getAscAlbum', null);
        List<AlbumModelEntity> album = List();
        list.forEach((item) => album.add(AlbumModelEntity.fromJson(item)));
      } else if ("getAlbumVideoAll" == data) {
        list = await SoftWareUtil.getAlbumVideo(maxCount: null);
      }
      replayTo.send(list);
    }
  }

  Future _sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  static FutureOr<List<AlbumModelEntity>> getAlbumImg(a) async {
    WidgetsFlutterBinding.ensureInitialized();
    List<AlbumModelEntity> list =
        await PhotoAlbumManager.getDescAlbumImg(maxCount: null);
    return list;
  }


  Future<List<AlbumModelEntity>> runComputeIsolate() async {
    var list = await compute(getAlbumImg, 8);
    print(list);
    return list;
  }
}
