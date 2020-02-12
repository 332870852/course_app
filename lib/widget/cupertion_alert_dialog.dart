import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertionDialog extends StatelessWidget {
  final String title;

  ///标题
  final String content;

  ///内容
  VoidCallback onOk;

  ///确认回调
  VoidCallback onCancel;

  ///退出回调
  ///确定按钮颜色
  Color btnOkColor;

  ///退出按钮颜色
  Color btnCancelColor;

  ///确认按钮使用lodaing
  bool isLoding;
  Color contextColor;
  double contextSize;
  CupertionDialog(
      {Key key,
        this.title,
        this.content,
        this.onOk,
        this.onCancel,
        this.btnOkColor = Colors.blue,
        this.btnCancelColor = Colors.grey,
        this.contextColor=Colors.blue,
        this.contextSize=15,
        this.isLoding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: (title!=null)?Text('$title'):null,
      content: Text(
        '${content}',
        style: TextStyle(color: contextColor,fontSize: contextSize),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('取消'),
          onPressed: () {
            onCancel();
            //Navigator.pop(context,0);
          },
          textStyle: TextStyle(color: btnCancelColor),
        ),
        CupertinoDialogAction(
          child: (isLoding) ? CupertinoActivityIndicator() : Text('确定'),
          onPressed: () {
            onOk();
            //Navigator.pop(context,1);
          },
          textStyle: TextStyle(color: btnOkColor),
        ),
        //
      ],
    );
  }
}
