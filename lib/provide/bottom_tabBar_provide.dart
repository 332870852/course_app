
import 'package:flutter/material.dart';

enum UnReadState{
  course_unRead,
  person_unRead,
  study_unRead,
  waitting_unRead
}
class BottomTabBarProvide with ChangeNotifier{

  int currentIndex=0; ///当前索引
  ///课堂互动未读消息
  int course_unRead=0;
  ///我的互动
  int person_unRead=0;
  ///我的学习
  int study_unRead=10;
  ///待办项目
  int waitting_unRead=21;

  ///改变tabBar的状态
  changeLeftAndRight(int index){
    currentIndex=index;
    notifyListeners();
  }

  ///改变未读取消息
  changeUnReadState({@required int flag,int num}){
    //assert(flag>=0&&flag <=4);
    switch(flag){
      case 0:
        // TODO: Handle this case.
        course_unRead=num;
        break;
      case 1:
        // TODO: Handle this case.
        person_unRead=num;
        break;
      case 2:
        // TODO: Handle this case.
        study_unRead=num;
        break;
      case 3:
        // TODO: Handle this case.
        waitting_unRead=num;
        break;
    }
    notifyListeners();
  }

}