import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///底部导航选项
Widget bottomItem(context, title, index) {
  return Container(
    height: ScreenUtil().setHeight(100),
    width: ScreenUtil().width,
    decoration: BoxDecoration(
        border:
        Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
    child: InkWell(
        onTap: () {
          Navigator.pop(context, index);
        },
        child: Center(
          child: Text(title),
        )),
  );
}