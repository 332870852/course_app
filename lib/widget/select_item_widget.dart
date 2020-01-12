import 'package:course_app/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectItemWidget extends StatelessWidget {
  final double height;
  final String title;
  GestureTapCallback onTap;
  Widget widget;

  SelectItemWidget(
      {Key key,
      @required this.title,
      @required this.height,
      this.widget,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Ink(
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Container(
                height: height,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(Constants.DividerColor),
                            width: Constants.DividerWith))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(40),
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        (widget != null) ? widget : SizedBox(),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.black26,
                          size: ScreenUtil().setSp(50),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
