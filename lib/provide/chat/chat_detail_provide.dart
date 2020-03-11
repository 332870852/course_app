import 'package:flutter/material.dart';
class ChatDetailProvide with ChangeNotifier {
  bool talkFOT = false;
  bool otherFOT = false;
  bool sendBtn = false;

  changeTalkFOT(bool state){
    this.talkFOT=state;
    notifyListeners();
  }

  changeOtherFOT(bool state){
    this.otherFOT=state;
    notifyListeners();
  }

  changeSendBtn(bool state){
    this.sendBtn=state;
    notifyListeners();
  }

  initState(){
     talkFOT = false;
     otherFOT = false;
     sendBtn = false;
     notifyListeners();
  }

}