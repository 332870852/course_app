import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tip_dialog/tip_dialog.dart';

//tip
class ToastWeb {
  static showInfoTip(BuildContext context,
      {String tip,
      FlushbarPosition position = FlushbarPosition.TOP,
      IconData iconData = Icons.info_outline,
      seconds = 3}) {
    TipDialogHelper.show(
        tipDialog: new TipDialog.customIcon(
      icon: new Icon(
        iconData,
        color: Colors.white,
        size: 30.0,
        textDirection: TextDirection.ltr,
      ),
      tip: tip,
    ));
  }
}
