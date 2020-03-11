
import 'package:common_utils/common_utils.dart';
import 'package:course_app/pages/scanViewDemo.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/utils/QRcodeScanUtil.dart';
import 'package:course_app/widget/progress_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';

class CommentMethod{

  static void scanMethodUtil(BuildContext context)async{
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler()
        .requestPermissions([PermissionGroup.camera]);
    if (permissions[PermissionGroup.camera] ==
        PermissionStatus.granted) {
      String url = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ScanViewDemo()));
      if(ObjectUtil.isEmptyString(url)){
        return ;
      }
      ProgressDialog pr =
      ProgressDialogWdiget.showProgressStatic(context,
          message: '请求中,请稍后..',
          type: ProgressDialogType.Normal,
          progressWidget: CupertinoActivityIndicator(
            radius: 20.0,
          ));
      print(url);
      getSys(context, url).then((onValue) async{
        if(onValue.code!=1){
          Fluttertoast.showToast(msg: onValue.result);
        }else{
          print(url);
          print(url.contains('getUserFriendById?findType=0'));
          if(url.contains('joinCode=')){
            pr.dismiss();
            QRCodeScanUtil.doResult(context, 1, onValue.data);
          }else if(url.contains('getUserFriendById?findType=0')){
            pr.dismiss();
            QRCodeScanUtil.doResult(context, 2, onValue.data);
          } else{
            Fluttertoast.showToast(msg: '二维码错误');
          }
        }
      }).catchError((onError){
        Fluttertoast.showToast(msg: onError.toString());
      }).whenComplete((){
        if(pr.isShowing()){
          pr.dismiss();
        }
      });
    }
  }
}