import 'package:flutter/material.dart';


class testprovide with ChangeNotifier{

  bool flag=false;
  change(){
    flag=!flag;
    notifyListeners();
  }
}
