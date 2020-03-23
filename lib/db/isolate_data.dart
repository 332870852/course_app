
class Isolates {
  ///get  datat
//  loadData(String method) async {
//    ReceivePort receivePort = ReceivePort();
//    await Isolate.spawn(_dataLoader, receivePort.sendPort);
//    SendPort sendPort = await receivePort.first;
//    List<AlbumModelEntity> list =
//        await _sendReceive(sendPort, "getAlbumImgAll");
//    print("recive:  ${list}");
//  }
//
//  ///to do
//  static _dataLoader(SendPort sendPort) async {
//    ReceivePort port = ReceivePort();
//    sendPort.send(port.sendPort);
//    await for (var msg in port) {
//      String data = msg[0];
//      SendPort replayTo = msg[1];
//      List<AlbumModelEntity> list = [];
//      if ("getAlbumImgAll" == data) {
////        list = await PhotoAlbumManager.getDescAlbumImg(
////            maxCount: null);
//
//        const MethodChannel _channel =
//            const MethodChannel('photo_album_manager');
//        List list = await _channel.invokeMethod('getAscAlbum', null);
//        List<AlbumModelEntity> album = List();
//        list.forEach((item) => album.add(AlbumModelEntity.fromJson(item)));
//      } else if ("getAlbumVideoAll" == data) {
//        list = await SoftWareUtil.getAlbumVideo(maxCount: null);
//      }
//      replayTo.send(list);
//    }
//  }
//
//  Future _sendReceive(SendPort port, msg) {
//    ReceivePort response = ReceivePort();
//    port.send([msg, response.sendPort]);
//    return response.first;
//  }





}
