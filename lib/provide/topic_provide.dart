import 'package:flutter/material.dart';
import 'package:course_app/data/topic_vo.dart';
import 'package:common_utils/common_utils.dart';

class TopicProvide with ChangeNotifier {
  List<TopicVo> data = [];

  //List<String> likes=[];

  saveData(source) {
    if (source != null) {
      data = source;
      notifyListeners();
    }
  }

  ///插入一条话题
  addTopoc(TopicVo topicVo) {
    if (ObjectUtil.isNotEmpty(topicVo)) {
      this.data.insert(0, topicVo);
      notifyListeners();
    }
  }

//  updateLikeNum(bool like, {String userId}) {
//    debugPrint('updateLikeNum');
//    if (like) {
//      if (!likes.contains(userId)) {
//        likes.add(userId);
//      }
//    } else {
//      likes.removeWhere((element) => element == userId);
//    }
//    notifyListeners();
//  }

  updateLikeNums(bool like, String topId, {String userId}) {
    debugPrint('updateLikeNums');
    int index = data.indexWhere((element) => element.id == topId);
    if (index == -1) return;
    if (like) {
      if (!data[index].likeNums.contains(userId)) {
        data[index].likeNums.add(userId);
      }
    } else {
      data[index].likeNums.removeWhere((element) => element == userId);
    }
    notifyListeners();
  }

  ///pl丶+1
  void increamentCom(topId) {
    int ind = data.indexWhere((element) => element.id == topId);
    if (ind == -1) return;
    data[ind].commentNums++;
    notifyListeners();
  }
}
