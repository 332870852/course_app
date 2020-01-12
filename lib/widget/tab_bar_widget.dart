import 'package:course_app/provide/create_course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class TabBarWidget extends StatelessWidget {
  final List<myTabBarItem> tabItem;

  TabBarWidget({Key key, this.tabItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Provide<CreateCourseProvide>(builder: (context, child, data) {
      int i = 0;
      return Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
//          children: <Widget>[
//            _myTabBarItem(context, data.currentIndex, 0,
//                title: '背景图片', width: 375.0),
//            _myTabBarItem(context, data.currentIndex, 1,
//                title: '背景颜色', width: 375.0),
//          ],
            children: (tabItem != null&&tabItem.length>0) ? tabItem.map((item) {
              return _myTabBarItem(context, data.currentIndex, i++,
                  title: item.title, width: MediaQuery
                      .of(context)
                      .size
                      .width);
            }).toList() : <Widget>[
              _myTabBarItem(context, data.currentIndex, 0,
                  title: '背景图片', width: 375.0),
              _myTabBarItem(context, data.currentIndex, 1,
                  title: '背景颜色', width: 375.0),
            ],
        ),
      );
    });
  }

  Widget _myTabBarItem(BuildContext context, int currentIndex, int indexTag,
      {@required title,
        Color selectColor = Colors.blue,
        Color unSelectColor = Colors.black26,
        height = 55.0,
        double width = 100.0}) {
    return GestureDetector(
      onTap: () {
        Provide.value<CreateCourseProvide>(context)
            .changecurrentIndex(indexTag);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(width),
        height: height,
        decoration: BoxDecoration(
          // color: Colors.red,
            border: Border(
                bottom: BorderSide(
                    width: 2.0,
                    color: (currentIndex == indexTag)
                        ? selectColor
                        : unSelectColor))),
        child: Text(
          title,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              color: (currentIndex == indexTag) ? selectColor : unSelectColor),
        ),
      ),
    );
  }
}

class myTabBarItem extends StatelessWidget {
  final int currentIndex;
  final int indexTag;
  final String title;
  Color selectColor;
  Color unSelectColor;
  double height;
  double width;

  myTabBarItem({Key key,
    @required this.title,
    @required this.currentIndex,
    @required this.indexTag,
    this.width = 100,
    this.height = 55.0,
    this.selectColor = Colors.blue,
    this.unSelectColor = Colors.black26})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provide.value<CreateCourseProvide>(context)
            .changecurrentIndex(indexTag);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(width),
        height: height,
        decoration: BoxDecoration(
          // color: Colors.red,
            border: Border(
                bottom: BorderSide(
                    width: 2.0,
                    color: (currentIndex == indexTag)
                        ? selectColor
                        : unSelectColor))),
        child: Text(
          title,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              color: (currentIndex == indexTag) ? selectColor : unSelectColor),
        ),
      ),
    );
  }
}
