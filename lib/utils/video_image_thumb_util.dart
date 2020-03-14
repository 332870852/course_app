import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
class ThumbnailResult {
  final Image image;
  final int dataSize;
  final double height;
  final double width;

  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

class VideoThumbUtil {
  final String pathUrl;

  VideoThumbUtil({@required this.pathUrl});

  ///获取缩略图
  Future<ThumbnailResult> genThumbnailImage(
      {ImageFormat format = ImageFormat.PNG,
      double maxHeight = 100.0,
      double maxWidth = 100.0,
      quality = 75}) async {
    //WidgetsFlutterBinding.ensureInitialized();
    Uint8List bytes;
    final Completer<ThumbnailResult> completer = Completer();
    bytes = await genThumbnailDATA(
        format: format,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        quality: quality);
    int _imageDataSize = bytes.length;
    print("image size: $_imageDataSize $maxWidth");
    final Image _image = Image.memory(
      bytes,
      fit: BoxFit.cover,
      width: maxWidth,
      height: maxHeight,
    ); //width: 200,height: 200,
    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(ThumbnailResult(
        image: _image,
        dataSize: _imageDataSize,
        height: _image.height,
        width: _image.width,
      ));
    }));

    return completer.future;
  }

  //缓存缩略图
  static Map<String,Uint8List> _thumbData=Map();
  static clearThumbData(){
     _thumbData.clear();
  }
  ///获取缩略图DATA
  Future<Uint8List> genThumbnailDATA(
      {ImageFormat format = ImageFormat.PNG,
      maxHeight = 100,
      maxWidth = 100,
      quality = 75}) async {
    if(_thumbData.containsKey(this.pathUrl)&&ObjectUtil.isNotEmpty(_thumbData[this.pathUrl])){
        return _thumbData[this.pathUrl];
    }
    Uint8List bytes;
    if (RegexUtil.isURL(pathUrl)) {
      bytes = await VideoThumbnail.thumbnailData(
          video: pathUrl,
          imageFormat: format,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          //timeMs: timeMs,
          quality: quality);
    } else {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: pathUrl,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: format,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          //timeMs: timeMs,
          quality: quality);
      print("thumbnail file is located: $thumbnailPath");
      final file = File(thumbnailPath);
      bytes = file.readAsBytesSync();
    }
    int _imageDataSize = bytes.length;
    print("image size: $_imageDataSize");
    if(_thumbData.length>15){
      _thumbData.clear();
    }
    _thumbData.putIfAbsent(this.pathUrl, ()=>bytes);
    return bytes;
  }
}

///视频压缩
class VideoCompressUtil {
  final _flutterVideoCompress = FlutterVideoCompress();

  FlutterVideoCompress getVideoCompressUtil() {
    return this._flutterVideoCompress;
  }


  /**
   * 视频小于5M，不压缩
   * 视频大于8M，视频品质压缩
   * 视频大于100M，默认压缩，
   * 大于150M，低质量压缩
   */
  static LimitCompressVideo(String path,
      {first = 5, second = 20, last = 100}) async {
    VideoCompressUtil util = VideoCompressUtil();
    MediaInfo mediaInfo = await util.getVideoInfo(path);
    debugPrint('videofilesize ：${mediaInfo.filesize}');
    if (mediaInfo.filesize <= first * 1000000) {
      debugPrint('不压缩');
      //5M压缩bu
      return mediaInfo;
    } else if (mediaInfo.filesize < second * 1000000) {
      debugPrint('MediumQuality');
      mediaInfo = await util.getCompressVideo(path,
          quality: VideoQuality.MediumQuality);
    }else if (mediaInfo.filesize < last * 1000000) {
      debugPrint('DefaultQuality');
      mediaInfo = await util.getCompressVideo(path,
          quality: VideoQuality.DefaultQuality);
    }else {
      debugPrint('LowQuality');
      mediaInfo =
          await util.getCompressVideo(path, quality: VideoQuality.LowQuality);
    }
    return mediaInfo;
  }

  //VideoCompressUtil({path});

  ///从视频路径获取缩略图
  Future<Uint8List> getThumb(String path, {quality = 50}) async {
    final uint8list = await _flutterVideoCompress.getThumbnail(path,
        quality: quality, // default(100)
        position: -1 // default(-1)
        );
    return uint8list;
  }

  ///从视频路径获取缩略图文件
  Future<File> getThumbnailFile(String path, {quality = 50}) async {
    final thumbnailFile = await _flutterVideoCompress.getThumbnailWithFile(path,
        quality: quality, // default(100)
        position: -1 // default(-1)
        );
    return thumbnailFile;
  }


  static Map<String, String> _cacheGif = new Map();
  ///清除gif缓存
  static clearCacheGif(){
     if(_cacheGif.length>0){
       _cacheGif.clear();
     }
  }
  ///将视频转换为gif
  Future<File> getGifFile(String videoPath,
      {startTime = 0, duration = 5, endTime = -1}) async {
    //防止重复生成gif
    if (_cacheGif.containsKey(videoPath) &&
        ObjectUtil.isNotEmpty(_cacheGif[videoPath])) {
      return File(_cacheGif[videoPath]);
    }

    if (endTime > 0) {
      MediaInfo mediaInfo = await getVideoInfo(videoPath);
      if (mediaInfo.duration < endTime * 1000) {
        //second
        endTime = mediaInfo.duration / 1000;
      }
    }
    final file = await _flutterVideoCompress.convertVideoToGif(
      videoPath,
      startTime: startTime, // default(0)
      duration: duration, // default(-1)
      endTime: endTime,
      // endTime: -1 // default(-1) When you do not know the end time
    );
    _cacheGif.putIfAbsent(videoPath, () => file.path);
    debugPrint(file.path);
    return file;
  }

  ///获取媒体信息
  Future<MediaInfo> getVideoInfo(String videoPath) async {
    final info = await _flutterVideoCompress.getMediaInfo(videoPath);
    debugPrint(info.toJson().toString());
    return info;
  }

  ///压缩视频
  Future<MediaInfo> getCompressVideo(String videoPath,
      {quality = VideoQuality.DefaultQuality}) async {
    final info = await _flutterVideoCompress.compressVideo(
      videoPath,
      quality: quality,
      // default(VideoQuality.DefaultQuality)
      deleteOrigin: false, // default(false)
    );
    debugPrint(info.toJson().toString());
    return info;
  }

  ///订阅压缩进度
  Subscription getProgress(void progrees(event),
      {Function onDone, Function onError}) {
    Subscription subscription = _flutterVideoCompress.compressProgress$
        .subscribe(progrees, onDone: onDone, onError: onError);
    return subscription;
  }

  ///
}

///image压缩
class ImageCompressUtil {
  ///保持宽高比例, fp或者path不能同时为空,默认超过500KB压缩
  static Future<File> getCompressImgWH(
      {File fp,
      String path,
      @required int targetWidth,
      quality = 80,
      percentage = 70,
      compreSize = 500}) async {
    if (fp == null) {
      fp = new File(path);
    }
    //保持比列
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(fp.path);
    if(properties.width>targetWidth){
      targetWidth=targetWidth;
    }else{
      targetWidth=properties.width;
    }
    print(
        'sss:  ${properties.width * properties.height}  ${properties.width} ${properties.height}');
    print(fp.lengthSync());
    File compressedFile = await FlutterNativeImage.compressImage(fp.path,
        quality: quality,
        targetWidth: targetWidth,
        targetHeight:
            (properties.height * targetWidth / properties.width).round());
    return compressedFile;
  }

  static Future<File> getCompressImg(File fp,
      {quality = 70,
      percentage = 70,
      targetWidth = 0,
      targetHeight = 0}) async {
    File compressedFile = await FlutterNativeImage.compressImage(fp.path,
        quality: quality,
        percentage: percentage,
        targetWidth: targetWidth,
        targetHeight: targetHeight);
    return compressedFile;
  }
}
