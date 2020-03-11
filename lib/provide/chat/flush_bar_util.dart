import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class FlushBarUtil {
  static Flushbar _fluashBar;

  static Flushbar getFlushBar(
    Duration durtion, {
    isDismissible = false,
    String title,
    String message,
    Widget titleText,
    Widget messageText,
    Widget icon,
    flushbarPosition = FlushbarPosition.TOP,
    backgroundColor = Colors.white,
    showProgressIndicator = false,
    AnimationController progressController,
    progressBackgroundColor,
    progressValueColor,
    onTap(flushbar),
    FlushbarDismissDirection dismissDirection =
        FlushbarDismissDirection.HORIZONTAL,
  }) {
    if (icon == null) {
      icon = Icon(
        Icons.file_upload,
        color: Colors.greenAccent,
      );
    }
    _fluashBar = Flushbar(
      title: '${title}',
      message: '${message}',
      flushbarPosition: flushbarPosition,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
//        boxShadows: [
//          BoxShadow(
//              color: Colors.blue[800],
//              offset: Offset(0.0, 2.0),
//              blurRadius: 3.0)
//        ],
      backgroundGradient:
          const LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      duration: durtion,
      icon: icon,
      //leftBarIndicatorColor: Colors.green,
      dismissDirection: dismissDirection,
      showProgressIndicator: showProgressIndicator,
      progressIndicatorController: progressController,
      progressIndicatorBackgroundColor: progressBackgroundColor,
      progressIndicatorValueColor: progressValueColor,
      titleText: titleText,
      messageText: messageText,
      borderRadius: 8.0,
      margin: const EdgeInsets.only(left: 10, right: 10),
      onTap: (flushbar) => onTap,
    );
    return _fluashBar;
  }

  Flushbar getInstance() {
    return _fluashBar;
  }

  Flushbar dismissed() {
    if (!_fluashBar.isDismissed()) {
      _fluashBar.isDismissed();
    }
  }
}
