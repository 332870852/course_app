import 'package:course_app/data/course_do.dart';
import 'package:flutter/material.dart';

class CreateCourseProvide with ChangeNotifier {

  ///初始化所有控件状态
  void InitStatus(){
    groupValueYear='${DateTime.now().year}-${DateTime.now().year + 1}';
    currentIndex = 0;
    bgkUrl = '';
    displayPro = false;
    displaySave=true;
    currentSem=null;
    selectedBgk=[];
    notifyListeners();
  }
  ////////////////////////////////////////控件状态//////////
  ///选择学年的radio控件
  var groupValueYear = '${DateTime.now().year}-${DateTime.now().year + 1}';

  ///当前tabBar的索引
  int currentIndex = 0;
  ///图片
  var bgkUrl = '';

  ///显示进度条
  bool displayPro = false;

  ///保存按钮的加载状态
  bool displaySave=true;

  ///选择背景色
 List<String> selectedBgk=[];
////////////////////////////////////////////////////

  ///学年
  var currentYear = '${DateTime.now().year}-${DateTime.now().year + 1}';

  ///学期
  var currentSem;

  ///要创建的课程信息
  CourseDo courseDo = CourseDo();

  ///年份
  void changeGroupValue(t) {
    groupValueYear = t;
    notifyListeners();
  }

  ///学期
  void changeGroupSem(t) {
    currentSem = t;
    notifyListeners();
  }

  ///选择年份
  void changeCurrentYear(t) {
    currentYear = t;
    notifyListeners();
  }

  ///索引
  void changecurrentIndex(int indexTag) {
    currentIndex = indexTag;
    notifyListeners();
  }

  ///修改背景图
  void changebgkUrl(String url) {
    bgkUrl = url;
    notifyListeners();
  }

  ///进度条显示
  void changeProgress({@required display}) {
    if (display == displayPro) {
      return;
    }
    displayPro = display;
    notifyListeners();
  }

  ///保存按钮的加载状态
  void changeDisplaySave({@required bool status}){
    displaySave=status;
    notifyListeners();
  }

  void AddselectedBgk({@required tag}){
    if(selectedBgk.length>0){
      selectedBgk.clear();
    }
     selectedBgk.add(tag);
     notifyListeners();
  }

  ///修改控件的状态
  void setModifyStatus({String url,int start,int end,String bgk,int sem}) {
    if(start!=null&&end!=null){
      groupValueYear = '${start}-${end}';
      print(groupValueYear);
    }
    bgkUrl=(url!=null)?url:'';
    selectedBgk=[bgk];
    currentSem=sem;
    currentIndex=0;
  }

}
