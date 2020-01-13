import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProgressDialogWdiget {

  ProgressDialog _pr;


  createProgressDialog(context,
      {String message,
      Color backgroundColor = Colors.white,
      double maxProgress = 100,
      TextStyle messageTextStyle,
        ProgressDialogType type=ProgressDialogType.Download,
        Widget progressWidget}) {
    _pr = new ProgressDialog(context, type: type);
    _pr.style(
        message: message,
        borderRadius: 10.0,
        backgroundColor: backgroundColor,
        elevation: 10.0,
        progressWidget: (progressWidget==null)?CircularProgressIndicator():progressWidget,
        progress: 0.0,
        maxProgress: maxProgress,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: (messageTextStyle == null)
            ? TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w600)
            : messageTextStyle);
    return _pr;
  }

  updateProgress(
      {@required double progress,
      String message = "Please wait...",
      Widget progressWidget}) {
    _pr.update(
      progress: progress,
      message: message,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: (progressWidget == null)
              ? CircularProgressIndicator()
              : progressWidget),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }

  void show() {
    _pr.show();
  }

  void dismiss() {
    _pr.dismiss();
  }

  void hide() {
    _pr.hide();
  }

  bool isShowing() {
    return _pr.isShowing();
  }

  static ProgressDialog getProgressDialog(context){
    ProgressDialogWdiget progressDialogWdiget= ProgressDialogWdiget();
    if(progressDialogWdiget._pr==null){
      return ProgressDialog(context);
    }
    return progressDialogWdiget._pr;
  }

  static ProgressDialog showProgressStatic(context,
      {String message,
      Color backgroundColor = Colors.white,
      double maxProgress = 100,
      TextStyle messageTextStyle,
        ProgressDialogType type=ProgressDialogType.Download,
        Widget progressWidget}) {
     ProgressDialog pr = ProgressDialogWdiget().createProgressDialog(context,
        message: message,
        backgroundColor: backgroundColor,
        maxProgress: maxProgress,
        messageTextStyle: messageTextStyle,
     progressWidget: progressWidget,
     type: type);
    pr.show();
    return pr;
  }

  static void updateProgressStatic(ProgressDialog pro,{@required double progress,
    String message = "Please wait...",
    Widget progressWidget}) {
    pro.update(
      progress: progress,
      message: message,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: (progressWidget == null)
              ? CircularProgressIndicator()
              : progressWidget),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }
}
