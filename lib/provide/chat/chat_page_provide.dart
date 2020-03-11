import 'package:flutter/material.dart';

class ChatPageProvide with ChangeNotifier {
  int currentIndex = 0; //0-消息，1-联系人

  changCureentIndex(int index) {
    this.currentIndex = index;
    notifyListeners();
  }

}
