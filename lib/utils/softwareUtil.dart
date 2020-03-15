import 'package:connectivity/connectivity.dart';
import 'package:course_app/router/application.dart';
import 'package:dio/dio.dart';
import 'package:photo_album_manager/album_model_entity.dart';
import 'package:photo_album_manager/photo_album_manager.dart';


class SoftWareUtil {
  //图库权限
  static bool getAlunmPermisson() {
    if (Application.sp.containsKey('getAlunmPermisson')) {
      bool b = Application.sp.getBool('getAlunmPermisson');
      return b;
    }
    return false;
  }

  static saveAlunmPermisson(bool flag) {
    Application.sp.setBool('getAlunmPermisson', flag);
  }

  static checkNetWork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    //TODO network
    if (connectivityResult == ConnectivityResult.none) {
      print('网络不可用,请检查网络');
      return null;
    }
  }

  static Future SoftPost(String url,
      {Map<String, dynamic> queryParameters, data}) async {
    await checkNetWork();
    Dio dio = new Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
      dio.interceptors.requestLock.lock();
      var device = Application.sp.get("device");
      options.headers.addAll({'device': device});
      dio.interceptors.requestLock.unlock();
      return options;
    }));
    Response response =
        await dio.post(url, data: data, queryParameters: queryParameters);
    try {
      if (response.statusCode == 200) {
        print(response);
        //ResponseModel responseModel = ResponseModel.fromJson(response.data);
        return response.data;
      } else {
        print('code: ${response.statusCode},data:${response.data}');
      }
    } catch (e) {
      throw e;
    }
    return null;
  }

  static Future Softget(String url,
      {Map<String, dynamic> queryParameters}) async {
    await checkNetWork();
    Dio dio = new Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
      dio.interceptors.requestLock.lock();
      var device = Application.sp.get("device");
      options.headers.addAll({'device': device});
      dio.interceptors.requestLock.unlock();
      return options;
    }));
    Response response = await dio.get(url, queryParameters: queryParameters);
    try {
      if (response.statusCode == 200) {
        print(response);
        return response.data;
      } else {
        print('code: ${response.statusCode},data:${response.data}');
      }
    } catch (e) {
      throw e;
    }
    return null;
  }

  ///////////////////////////////////////////

  ///////////////////////////////////////////////
  ///所有图库资源
  static Future<List<AlbumModelEntity>> getAllAlbums(
      {int maxCount = 1, orderBy = 'desc'}) async {
    List<AlbumModelEntity> list;
    if ('desc' == orderBy)
      list = await PhotoAlbumManager.getDescAlbum(maxCount: maxCount);
    else
      list = await PhotoAlbumManager.getAscAlbum(maxCount: maxCount);
    return list;
  }

  ///图片
  static Future<List<AlbumModelEntity>> getAlbumImg(
      {int maxCount = 20, orderBy = 'desc'}) async {
    List<AlbumModelEntity> list;
    if ('desc' == orderBy)
      list = await PhotoAlbumManager.getDescAlbumImg(maxCount: maxCount);
    else
      list = await PhotoAlbumManager.getAscAlbumImg(maxCount: maxCount);
    return list;
  }

  static Future<AlbumModelEntity> getOriginalImg(String localIdentifier) async {
    AlbumModelEntity albumModelEntity;
    albumModelEntity = await PhotoAlbumManager.getOriginalImg(localIdentifier);
    return albumModelEntity;
  }

  ///video
  static Future<List<AlbumModelEntity>> getAlbumVideo(
      {int maxCount = 20, orderBy = 'desc'}) async {
    List<AlbumModelEntity> list;
    if ('desc' == orderBy)
      list = await PhotoAlbumManager.getDescAlbumVideo(maxCount: maxCount);
    else
      list = await PhotoAlbumManager.getAscAlbumVideo(maxCount: maxCount);
    return list;
  }
}
