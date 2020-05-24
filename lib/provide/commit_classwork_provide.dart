import 'package:course_app/service/student_method.dart';
import 'package:flutter/material.dart';

///提交作业进度
class CommitClassWorkProvide with ChangeNotifier {
  List localFile = []; //要上传的本地文件
  List<Map> data=[]; //fid

  deleteFile(int index) {
    if (index > -1 && index < localFile.length) {
      localFile.removeAt(index);
      notifyListeners();
    }
  }

  //上传文件
  uploadFile(BuildContext context, Map map) async {
    localFile.add(map);
    notifyListeners();
    var fid=await StudentMethod.uploadClassWorkFile(context, path: '${map['file']}',
        onSendProgress: (count, total) {
      int i = localFile.indexWhere((element) => element['file'] == map['file']);
      if (i != -1) {
       // print('count: ${count}, total:${total}  ${(count / total)}');
        localFile[i]['value'] = (count / total) * 100;
        localFile[i]['visiable'] = ((count / total) != 1);
        notifyListeners();
      }
    });
    data.add({'fid':fid,'tag':map['file']});
  }

  void initData() {
    data.clear();
    localFile.clear();
    notifyListeners();
  }

}
