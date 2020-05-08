import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/service/user_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provide/provide.dart';
import 'package:path/path.dart';
import 'doucument_page_provide.dart';

///资料page
///

class FileOptProvide with ChangeNotifier {
  ///上传文件列表
  List uploadList = [];

  ///下载文件列表
  List downloadList = [];

  insertUpload(List upload) {
    //Widget item=;
    debugPrint('insertUpload');
    this.uploadList.addAll(upload);
    print(uploadList);
    notifyListeners();

    ///uploaad
    //uploadList.reversed;
  }

  uploadFiles(context, Map map, String courseId) async {
    List list = [];
    map.forEach((key, value) {
      list.add({
        'fname': key,
        'ftype': mime(key),
        'fsize': File(value).lengthSync(),
        'progress': 0,
        'finish': false
      });
    });
    insertUpload(list);
    map.forEach((name, path) async {
      var file = await UserMethod.uploadCourseFile(context,
          fineName: name,
          filePath: path,
          courseId: courseId, onSendProgress: (send, total) {
        _updateUploadProgrss(name, send, false);
      });
      if (file != null) {
        _updateUploadProgrss(name, 0, true);
        Provide.value<DoucumentPageProvide>(context).insertFiledDate(file);
      }
    });
  }

  _updateUploadProgrss(key, size, finish) {
    var index =
        this.uploadList.indexWhere((element) => element['fname'] == key);
    if (index != -1) {
      this.uploadList[index]['progress'] = size;
      this.uploadList[index]['finish'] = finish;
      notifyListeners();
    }
  }

  insertDownLoad(List downLoad) {
    debugPrint('insertDownLoad');
    this.downloadList.addAll(downLoad);
    notifyListeners();
  }

  void downloadFile(BuildContext context, List fileList) async {
    debugPrint('downloadFile');
    // List<String> downloadUrls=[];
    if (ObjectUtil.isNotEmpty(fileList)) {
      List list = [];
      fileList.forEach((element) {
        list.add({
          'fname': element['fileName'],
          'ftype': mime(element['ftype']),
          'fsize': element['fsize'],
          'progress': 0,
          'finish': false
        });
      });
      print(list);
      insertDownLoad(list);
      NavigatorUtil.goFileOptPage(context, initValue: 0);

      ///文件夹
      var path = await getExternalStorageDirectory();
      String savePath = join(path.path, 'download');
      var file = Directory(savePath);
      if (!file.existsSync()) {
        file.createSync();
      }
      fileList.forEach((element) async {
        Dio dio = new Dio();
        var response = await dio
            .download(element['urlPath'], savePath + '/${element['fileName']}',
                onReceiveProgress: (receive, total) {
          print('receive :${receive}, total: ${total}');
          _updateDownloadProgrss(element['fileName'], receive, false);
        });
        if (response.statusCode == 200) {
          _updateDownloadProgrss(element['fileName'], 0, true);
        }
      });
    }
  }

  _updateDownloadProgrss(key, size, finish) {
    var index =
        this.downloadList.indexWhere((element) => element['fname'] == key);
    if (index != -1) {
      this.downloadList[index]['progress'] = size;
      this.downloadList[index]['finish'] = finish;
      notifyListeners();
    }
  }
}
