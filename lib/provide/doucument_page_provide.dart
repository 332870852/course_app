import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/service/user_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:tip_dialog/tip_dialog.dart';

import 'file_opt_provide.dart';

///资料page
///
class DoucumentPageProvide with ChangeNotifier {
  //bool selectTOF = false;
  bool bottomTOF = false;
  bool selectAll = true;

  //bool cancelSel = true;
  List fileList = [];

  loadFileData(List data) {
    if (data != null) {
      data.forEach((element) {
        Map map = element;
        map.putIfAbsent('select', () => false);
      });
      this.fileList = data;
      notifyListeners();
      //return fileList;
    }

//    notifyListeners();
  }

  getFileData() async {
    return this.fileList;
  }

  ///insert
  insertFiledDate(data) {
    debugPrint('insertFiledDate');
    Map<String, dynamic> map = data;
    map.putIfAbsent('select', () => false);
    print(map);
    this.fileList.add(map);
    print('hhh         ${map}');
    notifyListeners();
    //this.fileList.add(data);
  }

  changeBottomTOF(bool status) {
    this.bottomTOF = status;
    notifyListeners();
  }

  changeSelectAll(bool status) {
    this.selectAll = status;
    if (status) {
      for (var i = 0; i < fileList.length; i++) {
        fileList[i]['select'] = false;
      }
    } else {
      for (var i = 0; i < fileList.length; i++) {
        fileList[i]['select'] = true;
      }
    }
    notifyListeners();
  }

  changeFileList(int index, var item) {
    if (index < fileList.length) {
      this.fileList[index] = item;
      notifyListeners();
    }
  }

  num selNums() {
    // int len=this.fileList.length;
    int n = 0;
    fileList.forEach((element) {
      if (element['select'] == true) {
        n++;
      }
    });
    return n;
  }

  void judgetAndOpt() {
    if (selNums() == fileList.length) {
      this.selectAll = false;
    } else if (selNums() == 0) {
      this.bottomTOF = false;
    } else {
      this.selectAll = true;
    }
    notifyListeners();
  }

  void deletefile(BuildContext context, String courseId) async {
    ///删除被选中的文件

    var b = await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('确认删除文件'),
            content: Text('删除后将无法恢复,确认继续删除文件名?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.black26),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  '确认',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
    if (b) {
      TipDialogHelper.loading('正在删除中,请稍等...');
      List<String> del = [];
      this.fileList.forEach((element) {
        if (element['select'] == true) {
          del.add(element['id']);
        }
      });
      List res = await UserMethod.deleteCourseFile(context,
              fid: del, courseId: courseId, type: 1)
          .catchError((error) {
//        TipDialogHelper.fail('删除失败');
//        Future.delayed(
//            Duration(milliseconds: 1000), () => TipDialogHelper.dismiss());
      }).whenComplete(() => TipDialogHelper.dismiss());

      if (ObjectUtil.isNotEmpty(res)) {
        TipDialogHelper.success('删除成功');
        this.fileList.removeWhere((element) => element['select'] == true);
        if (fileList.length == 0) {
          selectAll = true;
        }
        bottomTOF = false;
        notifyListeners();
        Future.delayed(
            Duration(milliseconds: 1000), () => TipDialogHelper.dismiss());
      }
    }
  }

  Future<List> download(BuildContext context) async{
    List down = [];
    this.fileList.forEach((element) async {
      if (element['select'] == true) {
        down.add(element);
      }
    });
    if(bottomTOF){
      this.bottomTOF = false;
      notifyListeners();
    }
    return down;
  }
}
