import 'package:course_app/provide/bottom_tabBar_provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class BottomTabBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<BottomTabBarProvide>(
      builder: (context, child, val) {
        return Container(
          //   color: Colors.pink,
          margin: EdgeInsets.only(top: 320),
          child: Stack(
            children: <Widget>[
              Container(
//                color: Colors.red,
                height: 50,
                child: Row(
                  children: <Widget>[
                    _myTabBarItem(context, val.currentIndex, 0,
                        title: '课堂互动', unRnumber: val.course_unRead),
                    _myTabBarItem(context, val.currentIndex, 1,
                        title: '我的互动', unRnumber: val.person_unRead),
                    _myTabBarItem(context, val.currentIndex, 2,
                        title: '我的学习', unRnumber: val.study_unRead),
                    _myTabBarItem(context, val.currentIndex, 3,
                        title: '待办事项', unRnumber: val.waitting_unRead),
                  ],
                ),
              ),
              DetailsWeb(),
//              Container(
//                padding: EdgeInsets.only(top: 50),
//                child: ListView.builder(itemBuilder: (context,index){
//                  return Text('暂无数据');
//                },itemCount: 100,),
//              ),
            ],
          ),
        );
      },
    );
  }

  Widget _myTabBarItem(BuildContext context, int currentIndex, int indexTag,
      {@required title, unRnumber}) {
    return InkWell(
      onTap: () {
        Provide.value<BottomTabBarProvide>(context)
            .changeLeftAndRight(indexTag);
        Provide.value<BottomTabBarProvide>(context)
            .changeUnReadState(flag: indexTag, num: 0);
      },
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(187.5),
            height: 55,
            decoration: BoxDecoration(
                // color: Colors.red,
                border: Border(
                    bottom: BorderSide(
                        width: 1.0,
                        color: (currentIndex == indexTag)
                            ? Theme.of(context).primaryColor
                            : Colors.black12))),
            child: Text(
              title,
              style: TextStyle(
                  color: (currentIndex == indexTag)
                      ? Theme.of(context).primaryColor
                      : Colors.black),
            ),
          ),
          (unRnumber != null && unRnumber > 0)
              ? Positioned(
                  child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      border: Border.all(width: 2, color: Colors.pink),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (unRnumber != null && unRnumber < 99)
                          ? unRnumber.toString()
                          : '99',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(25)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  top: 10,
                  right: 3,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Provide<BottomTabBarProvide>(
        builder: (context, child, val) {
          if (val.currentIndex == 0) {
            return Container(
              child: Text(
                '无数据',
              ),
            );
          } else if (val.currentIndex == 1) {
            return Container(
                width: ScreenUtil().setWidth(750),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text('暂时没有数据'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemBuilder: (context, index) {
                return Text('暂无数据');
              },
              itemCount: 100,
            );
          }
        },
      ),
    );
  }
}
