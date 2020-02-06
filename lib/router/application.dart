import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application{
  static Router router;
  static SharedPreferences sp;
  static initSp() async{
    sp = await SharedPreferences.getInstance();
  }
}