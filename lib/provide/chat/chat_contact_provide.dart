import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/chat/friend_model.dart';
import 'package:course_app/data/chat/request_friend.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flutter/material.dart';

//联系人
class ChatContactProvide with ChangeNotifier {
  ///索引 好友-班级
  int currentIndex = 0;

  ///好友资料
  List<UserInfoVo> friendsInfo = [];

  ///id
  // List<String> myfiendsVos=[];

//   saveMyFriendsVos(List<MyFriendsVo> list){
//     this.myfiendsVos.clear();
//     if(list!=null){
//       list.forEach((item){
//         if(!this.myfiendsVos.contains(item.myFriendUserId)){
//           print('${item.myFriendUserId}     ${myfiendsVos.length}');
//           this.myfiendsVos.add(item.myFriendUserId);
//         }
//       });
//     }
//   }

  List<String> queryMyFriendIds(List<MyFriendsVo> list) {
    List<String> res = [];
    if (list != null) {
      list.forEach((item) {
        res.add(item.myFriendUserId);
      });
    }
    return res;
  }

  ///////////////////////////

  changeCurrentIndex(int index) {
    this.currentIndex = index;
    notifyListeners();
  }

  //获取单个好友资料
  Future<UserInfoVo> searchFiend(BuildContext context,String fid) async{
    if(this.friendsInfo.length==0){
      getMyFriendsInfo();
      print('this.friendsInfo.length ${this.friendsInfo.length}');
    }
    int index =
        this.friendsInfo.indexWhere((item) => item.userId.toString() == fid);
    if (index != -1) {
      return this.friendsInfo[index];
    } else {
     var res= await UserMethod.getUserInfo(context, userId: fid);
      return res;
    }
  }

  //批量获取好友资料
  Future getFriendsInfo(BuildContext context, List<String> friendIds) async {
    List<UserInfoVo> friendsInfo =
        await UserMethod.getFriendsUserInfo(context, friendIds);
    print(friendsInfo);
    if (friendsInfo != null) {
      saveMyFriendsInfo(friendsInfo);
    }
    return friendIds;
  }

  //保存好友资料
  saveMyFriendsInfo(List<UserInfoVo> friendsInfo) {
    debugPrint("saveMyFriendsInfo");
    this.friendsInfo = friendsInfo;
    List<String> temp = [];
    this.friendsInfo.forEach((item) {
      temp.add(json.encode(item));
    });
    print('saveMyFriendsInfo ${temp}');
    Application.sp.setStringList('friendsInfoList', temp);
    notifyListeners();
    //getMyFriendsInfo();
  }

  //获取
  Future getMyFriendsInfo() async {
    debugPrint("getMyFriendsInfo");
    List<String> temp = Application.sp.getStringList('friendsInfoList');
    List<UserInfoVo> tempInfo = [];
    temp.forEach((item) {
      UserInfoVo userInfoVo = UserInfoVo.fromJson(json.decode(item));
      tempInfo.add(userInfoVo);
    });
    this.friendsInfo = tempInfo;
    print('getMyFriendsInfo ${tempInfo}');
    notifyListeners();
    return this.friendsInfo;
  }

  //添加好友资料
  insertMyFriendsInfo(BuildContext context, UserInfoVo userInfoVo) async {
    debugPrint('insert -- ${userInfoVo.toString()}');
    if (ObjectUtil.isNotEmpty(userInfoVo)) {
      bool flag = false;
      this.friendsInfo.forEach((item) {
        if (item.userId == userInfoVo.userId) flag = true;
      });
      if (flag) return null;
      this.friendsInfo.insert(0, userInfoVo);
      saveMyFriendsInfo(this.friendsInfo);
      debugPrint('insert -- ${this.friendsInfo.toString()}');
    }
  }
}
